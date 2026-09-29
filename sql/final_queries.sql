-- ============================================================
-- Unicorn Sales Analysis – Final Queries
-- ============================================================
-- Zweck: Finale SQL-Analyse des Unicorn-Datensatzes
-- Datenbank: Unicorn / PostgreSQL
-- Zeitraum: 2015–2018
-- Autor: Jesco-Joachim Schnebel
-- Datum: 05.09.2026
-- ============================================================


-- ============================================================
-- Q1: Wie hoch ist der Gesamtumsatz pro Jahr und wie hoch ist
--     die Wachstumsrate gegenüber dem jeweiligen Vorjahr?
--
-- Ausgabe: 4 Zeilen – eine pro Jahr
-- Granularität: Jahresebene
-- Methode: Jahresumsatz aggregieren und mit LAG den
--          Vorjahresumsatz für die Wachstumsberechnung ermitteln
-- ============================================================


WITH yearly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date)::int AS year,
        SUM(od.order_sales) AS revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    GROUP BY
        EXTRACT(YEAR FROM o.order_date)
)
SELECT
    year,
    revenue,
    LAG(revenue) OVER (
        ORDER BY year
    ) AS previous_year_revenue,
    ROUND(
        (
            100.0 * (
                revenue - LAG(revenue) OVER (ORDER BY year)
            )
            / NULLIF(LAG(revenue) OVER (ORDER BY year), 0)
        )::numeric,
        1
    ) AS yoy_growth_pct
FROM yearly_revenue
ORDER BY
    year;


-- ============================================================
-- Q2: Welche Region treibt das stärkste Wachstum in den
--     Jahren 2017–2018 und um wie viel?
--
-- Ausgabe: 4 Zeilen – eine pro Region
-- Granularität: Regionsebene
-- Methode: Umsatz pro Region und Jahr aggregieren, mit LAG
--          den Vorjahresumsatz bestimmen und anschließend
--          die Wachstumsrate von 2017 auf 2018 berechnen
-- ============================================================


WITH region_year_revenue AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date)::int AS year,
        o.shipping_region,
        SUM(od.order_sales) AS revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    WHERE o.order_date >= '2017-01-01'
        AND o.order_date < '2019-01-01'
    GROUP BY
        EXTRACT(YEAR FROM o.order_date),
        o.shipping_region
),
with_previous_year AS (
    SELECT
        year,
        shipping_region,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY shipping_region
            ORDER BY year
        ) AS previous_year_revenue
    FROM region_year_revenue
)
SELECT
    year,
    shipping_region,
    revenue,
    previous_year_revenue,
    ROUND(
        (
            100.0 * (revenue - previous_year_revenue)
            / NULLIF(previous_year_revenue, 0)
        )::numeric,
        1
    ) AS yoy_growth_pct
FROM with_previous_year
WHERE year = 2018
ORDER BY
    yoy_growth_pct DESC;


-- ============================================================
-- Q3: Wer sind innerhalb der am schnellsten wachsenden Region
--     die Top-3-Kunden nach Umsatz in 2017–2018?
--
-- Ausgabe: 3 Zeilen – eine pro Top-Kunde
-- Granularität: Kundenebene
-- Methode: Kundenumsatz in der Region West für 2017–2018
--          aggregieren und mit ROW_NUMBER nach Umsatz ordnen
-- ============================================================

WITH customer_revenue AS (
    SELECT
        o.customer_id,
        c.customer_name,
        SUM(od.order_sales) AS revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    JOIN customers c
        ON c.customer_id = o.customer_id
    WHERE o.shipping_region = 'West'
        AND o.order_date >= '2017-01-01'
        AND o.order_date < '2019-01-01'
    GROUP BY
        o.customer_id,
        c.customer_name
),
ranked_customers AS (
    SELECT
        customer_id,
        customer_name,
        revenue,
        ROW_NUMBER() OVER (
            ORDER BY revenue DESC
        ) AS customer_rank
    FROM customer_revenue
)
SELECT
    customer_rank,
    customer_id,
    customer_name,
    revenue
FROM ranked_customers
WHERE customer_rank <= 3
ORDER BY
    customer_rank;


-- ============================================================
-- Q4: Welcher Anteil des Gesamtumsatzes geht durch das
--     Rabattprogramm gegenüber einem hypothetischen
--     Szenario ohne Rabatte verloren?
--
-- Ausgabe: 1 Zeile – Gesamtbetrachtung 2015–2018
-- Granularität: Gesamtdatensatz
-- Methode: Jede Auftragsposition anhand ihres individuellen
--          Rabattwertes auf den hypothetischen Umsatz ohne
--          Rabatt zurückrechnen und anschließend aggregieren
-- Hinweis: Das Szenario unterstellt unveränderte Absatzmengen
--          auch ohne Rabatte.
-- ============================================================

WITH discount_impact AS (
    SELECT
        order_sales,
        order_sales / NULLIF(1 - order_discount, 0)
            AS revenue_without_discount
    FROM order_details
)
SELECT
    ROUND(SUM(order_sales)::numeric, 2)
        AS actual_revenue,
    ROUND(SUM(revenue_without_discount)::numeric, 2)
        AS revenue_without_discount,
    ROUND(
        (SUM(revenue_without_discount) - SUM(order_sales))::numeric,
        2
    ) AS revenue_lost_to_discounts,
    ROUND(
        (
            100.0
            * (SUM(revenue_without_discount) - SUM(order_sales))
            / NULLIF(SUM(revenue_without_discount), 0)
        )::numeric,
        2
    ) AS revenue_lost_pct
FROM discount_impact;


-- ============================================================
-- Q5: Welche Produktkategorien tragen die Auftragspositionen
--     mit negativem Gewinn am stärksten?
--
-- Ausgabe: 3 Zeilen – eine pro Produktkategorie
-- Granularität: Kategorieebene
-- Methode: Auftragspositionen mit negativem Gewinn filtern,
--          je Produktkategorie zählen und die negativen
--          Gewinne je Kategorie summieren
-- ============================================================

SELECT
    p.product_category,
    COUNT(*) AS negative_margin_line_items,
    SUM(od.order_profits) AS total_negative_profit
FROM order_details od
JOIN product p
    ON p.product_id = od.product_id
WHERE od.order_profits < 0
GROUP BY
    p.product_category
ORDER BY
    total_negative_profit ASC;


-- ============================================================
-- Q6: Datengrundlage für die Handlungsempfehlung
-- Furniture nach Rabattgruppe und Profitabilität
-- ============================================================

SELECT
    CASE
        WHEN od.order_discount = 0 THEN 'Kein Rabatt'
        WHEN od.order_discount <= 0.10 THEN 'Bis 10 %'
        WHEN od.order_discount <= 0.20 THEN '11–20 %'
        WHEN od.order_discount <= 0.30 THEN '21–30 %'
        ELSE 'Über 30 %'
    END AS discount_group,
    COUNT(*) AS line_items,
    ROUND(SUM(od.order_sales)::numeric, 2) AS revenue,
    ROUND(SUM(od.order_profits)::numeric, 2) AS profit,
    ROUND(
        (
            SUM(od.order_profits)
            / NULLIF(SUM(od.order_sales), 0)
            * 100
        )::numeric,
        2
    ) AS profit_margin_pct
FROM order_details od
JOIN product p
    ON p.product_id = od.product_id
WHERE p.product_category = 'Furniture'
GROUP BY
    CASE
        WHEN od.order_discount = 0 THEN 'Kein Rabatt'
        WHEN od.order_discount <= 0.10 THEN 'Bis 10 %'
        WHEN od.order_discount <= 0.20 THEN '11–20 %'
        WHEN od.order_discount <= 0.30 THEN '21–30 %'
        ELSE 'Über 30 %'
    END
ORDER BY
    profit_margin_pct ASC;