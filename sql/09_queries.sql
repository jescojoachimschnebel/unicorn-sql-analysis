
-- ============================================================
-- DATEI: 01_audit\exploration.sql
-- ============================================================

/*
=====================================================
Unicorn Project
Week 1 - Exploration Queries

Author: Jesco J. Schnebel
Purpose:
Exploratory SQL queries used to understand the Unicorn
database before starting the business analysis.
=====================================================
*/

-- Exploration 1: Kundensegmente
SELECT DISTINCT
    customer_segment
FROM customers
ORDER BY customer_segment;

-- Exploration 2: Bestellungen pro Versandregion
SELECT
    shipping_region,
    COUNT(*) AS total_orders
FROM orders
GROUP BY shipping_region
ORDER BY total_orders DESC;

-- Exploration 3: Die 10 höchsten Verkaufssummen
SELECT
    order_details_id,
    order_id,
    product_id,
    order_sales
FROM order_details
ORDER BY order_sales DESC
LIMIT 10;

-- Exploration 4: Produktkategorien und Unterkategorien
SELECT DISTINCT
    product_category,
    product_subcategory
FROM product
ORDER BY
    product_category,
    product_subcategory;

-- Exploration 5: Anzahl der Bestellungen pro Kunde
SELECT
    customer_id,
    COUNT(*) AS anzahl_bestellungen
FROM orders
GROUP BY customer_id
ORDER BY anzahl_bestellungen DESC;

-- ============================================================
-- DATEI: 02_qa\assertions.sql
-- ============================================================

-- =========================================
-- ASSERTIONS — Unicorn Project
-- QA Baseline (July 2026)
-- =========================================
--
-- Run all assertions and compare each result
-- with the documented baseline.
--
-- If a value differs from the expected result,
-- investigate before continuing the analysis.


-- =========================================
-- ASSERTION 1: Missing postal codes
-- =========================================
-- Checks the number of orders without a
-- shipping postal code.
--
-- Healthy result:
-- missing_shipping_postal_codes = 6
--
-- A different value means that the number of
-- incomplete shipping addresses has changed.

SELECT
    COUNT(*) AS missing_shipping_postal_codes
FROM orders
WHERE shipping_postal_code IS NULL
   OR TRIM(shipping_postal_code::text) = '';


-- =========================================
-- ASSERTION 2: Non-positive sales
-- =========================================
-- Checks whether order-detail records contain
-- sales values equal to or below zero.
--
-- Healthy result:
-- non_positive_sales = 1
--
-- A higher value could affect revenue and
-- profitability calculations.

SELECT
    COUNT(*) AS non_positive_sales
FROM order_details
WHERE order_sales <= 0;


-- =========================================
-- ASSERTION 3: Negative profits
-- =========================================
-- Checks the number of order-detail records
-- with a negative profit.
--
-- Healthy result:
-- negative_profit_rows = 1864
--
-- A different value means that the baseline
-- for profitability analysis has changed.

SELECT
    COUNT(*) AS negative_profit_rows
FROM order_details
WHERE order_profits < 0;


-- =========================================
-- ASSERTION 4: Customers without orders
-- =========================================
-- Checks the number of customers that cannot
-- be matched to an order.
--
-- Healthy result:
-- customers_without_orders = 2
--
-- A different value could affect customer-level
-- analyses and customer coverage calculations.

SELECT
    COUNT(*) AS customers_without_orders
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- ============================================================
-- DATEI: 02_qa\business_slice.sql
-- ============================================================

-- ============================================================
-- Unicorn-Projekt – Business Slice
-- ============================================================

/*
English version
BUSINESS SLICE — Unicorn Project

Returns the rows we'll analyse for the rest of the project.

Choices documented in:
02_qa/slice_notes.md
*/

/*
Deutsche Version
BUSINESS SLICE – Unicorn-Projekt

Dieser Datenausschnitt bildet die Grundlage für alle weiteren Analysen
im Unicorn-Projekt.

Die getroffenen Filterentscheidungen sind in
02_qa/slice_notes.md dokumentiert.
*/

-- ============================================================
-- Unicorn-Projekt – Business Slice Vorbereitung
-- Datenbestand analysieren
-- ============================================================

-- 1. Welche Lieferländer gibt es?
SELECT DISTINCT
    shipping_country
FROM orders
ORDER BY shipping_country;

-- 2. Welche Versandarten gibt es?
SELECT DISTINCT
    shipping_mode
FROM orders
ORDER BY shipping_mode;

-- 3. Welchen Zeitraum decken die Bestelldaten ab?
SELECT
    MIN(order_date) AS erste_bestellung,
    MAX(order_date) AS letzte_bestellung
FROM orders;

-- 4. Wie verteilen sich die Bestellungen auf die Versandarten?
SELECT
    shipping_mode,
    COUNT(*) AS total_orders
FROM orders
GROUP BY shipping_mode
ORDER BY total_orders DESC;

-- ============================================================
-- Business Slice
-- Datenausschnitt für alle weiteren Analysen
-- ============================================================

SELECT *
FROM orders
WHERE order_date BETWEEN '2016-01-01' AND '2017-12-31';



-- ============================================================
-- DATEI: 02_qa\qa_checks.sql
-- ============================================================

/*
=====================================================
QA CHECKS – Unicorn-Projekt

Autor: Jesco-Joachim Schnebel

Zweck:
Gezielte Qualitätsprüfungen für die Tabellen customers,
orders, order_details und product.

Geprüft werden:
- Zeilenanzahl
- fehlende Werte
- eindeutige Werte
- Duplikate
- Wertebereiche und unplausible Werte
=====================================================
*/


-- =========================================
-- QA CHECKS – customers
-- =========================================

-- 1. Zeilenanzahl
SELECT
    COUNT(*) AS row_count
FROM customers;

-- 2. Fehlende Kundennamen
SELECT
    COUNT(*) AS missing_customer_name
FROM customers
WHERE customer_name IS NULL
   OR TRIM(customer_name) = '';

-- 3. Fehlende Kundensegmente
SELECT
    COUNT(*) AS missing_customer_segment
FROM customers
WHERE customer_segment IS NULL
   OR TRIM(customer_segment) = '';

-- 4. Vorhandene Kundensegmente
SELECT DISTINCT
    customer_segment
FROM customers
ORDER BY customer_segment;

-- 5. Prüfung auf doppelte customer_id-Werte
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 6. Doppelte Kundennamen
SELECT
    customer_name,
    COUNT(*) AS name_count
FROM customers
GROUP BY customer_name
HAVING COUNT(*) > 1
ORDER BY name_count DESC;


-- =========================================
-- QA CHECKS – orders
-- =========================================

-- 1. Zeilenanzahl
SELECT
    COUNT(*) AS row_count
FROM orders;

-- 2. Fehlende Bestelldaten
SELECT
    COUNT(*) AS missing_order_date
FROM orders
WHERE order_date IS NULL;

-- 3. Fehlende Versanddaten
SELECT
    COUNT(*) AS missing_shipping_date
FROM orders
WHERE shipping_date IS NULL;

-- 4. Fehlende Versandorte
SELECT
    COUNT(*) AS missing_shipping_location
FROM orders
WHERE shipping_city IS NULL
   OR TRIM(shipping_city) = ''
   OR shipping_state IS NULL
   OR TRIM(shipping_state) = ''
   OR shipping_region IS NULL
   OR TRIM(shipping_region) = '';

-- 5. Fehlende Postleitzahlen
SELECT
    COUNT(*) AS missing_shipping_postal_code
FROM orders
WHERE shipping_postal_code IS NULL;

-- 6. Vorhandene Versandregionen
SELECT DISTINCT
    shipping_region
FROM orders
ORDER BY shipping_region;

-- 7. Vorhandene Versandarten
SELECT DISTINCT
    shipping_mode
FROM orders
ORDER BY shipping_mode;

-- 8. Prüfung auf doppelte order_id-Werte
SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- 9. Unplausible Versanddaten
SELECT
    COUNT(*) AS shipping_before_order
FROM orders
WHERE shipping_date < order_date;

-- 10. Datumsbereich
SELECT
    MIN(order_date) AS earliest_order_date,
    MAX(order_date) AS latest_order_date,
    MIN(shipping_date) AS earliest_shipping_date,
    MAX(shipping_date) AS latest_shipping_date
FROM orders;

-- 11. Versanddauer
SELECT
    MIN(shipping_date::date - order_date::date) AS min_days_to_ship,
    MAX(shipping_date::date - order_date::date) AS max_days_to_ship,
    AVG(shipping_date::date - order_date::date) AS avg_days_to_ship
FROM orders;


-- =========================================
-- QA CHECKS – order_details
-- =========================================

-- 1. Zeilenanzahl
SELECT
    COUNT(*) AS row_count
FROM order_details;

-- 2. Fehlende Fremdschlüssel
SELECT
    COUNT(*) AS missing_foreign_keys
FROM order_details
WHERE order_id IS NULL
   OR product_id IS NULL;

-- 3. Prüfung auf doppelte order_details_id-Werte
SELECT
    order_details_id,
    COUNT(*) AS duplicate_count
FROM order_details
GROUP BY order_details_id
HAVING COUNT(*) > 1;

-- 4. Ungültige Mengen
SELECT
    COUNT(*) AS invalid_quantity
FROM order_details
WHERE quantity IS NULL
   OR quantity <= 0;

-- 5. Auffällige Rabatte
SELECT
    COUNT(*) AS invalid_discount
FROM order_details
WHERE order_discount IS NULL
   OR order_discount < 0
   OR order_discount > 1;

-- 6. Ungültige oder auffällige Verkaufswerte
SELECT
    COUNT(*) AS non_positive_sales
FROM order_details
WHERE order_sales IS NULL
   OR order_sales <= 0;

-- 7. Negative Gewinne
SELECT
    COUNT(*) AS negative_profit_rows
FROM order_details
WHERE order_profits < 0;

-- 8. Fehlende Gewinnwerte
SELECT
    COUNT(*) AS missing_profit_values
FROM order_details
WHERE order_profits IS NULL
   OR order_profit_ratio IS NULL;

-- 9. Wertebereiche
SELECT
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity,
    MIN(order_discount) AS min_discount,
    MAX(order_discount) AS max_discount,
    MIN(order_sales) AS min_sales,
    MAX(order_sales) AS max_sales,
    MIN(order_profits) AS min_profit,
    MAX(order_profits) AS max_profit,
    MIN(order_profit_ratio) AS min_profit_ratio,
    MAX(order_profit_ratio) AS max_profit_ratio
FROM order_details;

-- 10. Fremdschlüssel ohne passende Bestellung
SELECT
    COUNT(*) AS orphan_order_ids
FROM order_details od
LEFT JOIN orders o
    ON od.order_id = o.order_id
WHERE o.order_id IS NULL;

-- 11. Fremdschlüssel ohne passendes Produkt
SELECT
    COUNT(*) AS orphan_product_ids
FROM order_details od
LEFT JOIN product p
    ON od.product_id = p.product_id
WHERE p.product_id IS NULL;


-- =========================================
-- QA CHECKS – product
-- =========================================

-- 1. Zeilenanzahl
SELECT
    COUNT(*) AS row_count
FROM product;

-- 2. Fehlende Produktnamen
SELECT
    COUNT(*) AS missing_product_name
FROM product
WHERE product_name IS NULL
   OR TRIM(product_name) = '';

-- 3. Fehlende Kategorien oder Unterkategorien
SELECT
    COUNT(*) AS missing_category_values
FROM product
WHERE product_category IS NULL
   OR TRIM(product_category) = ''
   OR product_subcategory IS NULL
   OR TRIM(product_subcategory) = '';

-- 4. Prüfung auf doppelte product_id-Werte
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- 5. Doppelte Produktnamen
SELECT
    product_name,
    COUNT(*) AS name_count
FROM product
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY name_count DESC;

-- 6. Vorhandene Produktkategorien
SELECT DISTINCT
    product_category
FROM product
ORDER BY product_category;

-- 7. Vorhandene Produkt-Unterkategorien
SELECT DISTINCT
    product_subcategory
FROM product
ORDER BY product_subcategory;

-- 8. Fehlende Herstellerangaben
SELECT
    COUNT(*) AS missing_manufacturer
FROM product
WHERE product_manufacturer IS NULL
   OR TRIM(product_manufacturer) = '';



/*
✔️ Row Count
✔️ NULL-Checks
✔️ Prüfung auf doppelte IDs
✔️ Wertebereiche (MIN/MAX)
✔️ Fremdschlüssel-Prüfungen
✔️ Bereichsprüfungen
*/

-- ============================================================
-- DATEI: 03_kpis\individual_kpis.sql
-- ============================================================

/*
=====================================================
Unicorn-Projekt – Woche 3

Einzelne KPI-Berechnungen

Autor: Jesco J. Schnebel

Zweck:
Berechnung einzelner KPIs auf Basis der Tabelle order_details.

Die KPIs entsprechen den Definitionen aus
kpi_definitions.md.
=====================================================
*/

-- ============================================================
-- KPI 1: Gesamtumsatz
-- Definition: Summe von order_sales
-- ============================================================

SELECT
    ROUND(SUM(order_sales)::numeric, 2) AS total_revenue
FROM order_details;


-- ============================================================
-- KPI 2: Gesamtgewinn
-- Definition: Summe von order_profits
-- ============================================================

SELECT
    ROUND(SUM(order_profits)::numeric, 2) AS total_profit
FROM order_details;


-- ============================================================
-- KPI 3: Gesamtgewinnmarge
-- Definition: Gesamtgewinn geteilt durch Gesamtumsatz
-- ============================================================

SELECT
    ROUND(
        (SUM(order_profits) / NULLIF(SUM(order_sales), 0) * 100)::numeric,
        2
    ) AS profit_margin_percent
FROM order_details;


-- ============================================================
-- KPI 4: Durchschnittliche Rabattquote
-- Definition: Durchschnittlicher Rabatt aller Bestellpositionen
-- ============================================================

SELECT
    ROUND(
        (AVG(order_discount) * 100)::numeric,
        2
    ) AS avg_discount_percent
FROM order_details;


-- ============================================================
-- KPI 5: Anteil profitabler Bestellpositionen
-- Definition: Prozentualer Anteil der Bestellpositionen
--             mit einem Gewinn größer oder gleich 0
-- ============================================================

SELECT
    ROUND(
        (
            COUNT(CASE WHEN order_profits >= 0 THEN 1 END)::numeric
            / COUNT(*)
            * 100
        ),
        2
    ) AS profitable_positions_percent
FROM order_details;

-- ============================================================
-- DATEI: 03_kpis\segmented_kpis.sql
-- ============================================================

/*
=====================================================
Unicorn-Projekt – Woche 3

Segmentierte KPIs und Geschäftsregeln

Autor: Jesco J. Schnebel

Zweck:
Erweiterung der KPI-Analyse um segmentierte Auswertungen
und CASE-basierte Geschäftsregeln auf Basis von order_details.
=====================================================
*/


-- ============================================================
-- Segmentierter KPI: Rabattgruppe × Gewinnstatus
-- ============================================================
-- Warum ist das relevant?
-- Die reine Betrachtung der Rabattgruppen zeigt nur Umsatz und Gewinn
-- je Rabattstufe. Durch die zusätzliche Unterteilung in profitable und
-- verlustbringende Positionen wird sichtbar, ob bestimmte Rabattstufen
-- besonders häufig mit Verlusten verbunden sind.
-- ============================================================

SELECT
    CASE
        WHEN order_discount = 0 THEN 'Kein Rabatt'
        WHEN order_discount <= 0.10 THEN 'Leichter Rabatt'
        WHEN order_discount <= 0.25 THEN 'Mittlerer Rabatt'
        ELSE 'Hoher Rabatt'
    END AS discount_tier,
    CASE
        WHEN order_profits >= 0 THEN 'Profitabel'
        ELSE 'Verlust'
    END AS profit_status,
    COUNT(*) AS positionen,
    ROUND(SUM(order_sales)::numeric, 2) AS umsatz,
    ROUND(SUM(order_profits)::numeric, 2) AS gewinn
FROM order_details
GROUP BY
    discount_tier,
    profit_status
ORDER BY
    discount_tier,
    profit_status;


-- ============================================================
-- Geschäftsregel: Bestellgrößen-Kategorien
-- ============================================================
-- Warum ist das relevant?
-- Die Einteilung der Bestellpositionen nach Bestellmenge zeigt,
-- ob größere Mengen auch wirtschaftlich bessere Ergebnisse liefern.
-- Dadurch können kleine, mittlere und große Bestellmengen
-- hinsichtlich Umsatz und Profitabilität verglichen werden.
-- ============================================================


SELECT
    CASE
        WHEN quantity = 1 THEN 'Einzelposition'
        WHEN quantity <= 3 THEN 'Kleine Bestellung'
        WHEN quantity <= 7 THEN 'Mittlere Bestellung'
        ELSE 'Große Bestellung'
    END AS bestellgroesse,
    COUNT(*) AS positionen,
    ROUND(SUM(order_sales)::numeric, 2) AS umsatz,
    ROUND(SUM(order_profits)::numeric, 2) AS gewinn,
    ROUND(
        (
            SUM(order_profits)
            / NULLIF(SUM(order_sales), 0)
            * 100
        )::numeric,
        2
    ) AS gewinnmarge_prozent
FROM order_details
GROUP BY bestellgroesse
ORDER BY umsatz DESC;

-- Ergebnis:
-- Mittlere Bestellungen erzielen mit 1.185.380 € den höchsten Umsatz,
-- weisen mit 11,65 % jedoch die niedrigste Gewinnmarge auf.
-- Dies deutet darauf hin, dass ein hohes Umsatzvolumen nicht automatisch
-- mit einer höheren Profitabilität verbunden ist.

-- ============================================================
-- DATEI: 03_kpis\summary_query.sql
-- ============================================================

/*
=====================================================
Unicorn-Projekt – Woche 3

KPI-Übersichtstabelle

Autor: Jesco J. Schnebel

Zweck:
Zusammenfassung der wichtigsten KPIs aus order_details
in einem gemeinsamen Resultset.

Die einzelnen KPI-Berechnungen wurden zuvor in
individual_kpis.sql geprüft.
=====================================================
*/


-- ============================================================
-- KPI-Übersicht
-- Eine Zeile pro KPI
-- ============================================================

SELECT
    'Gesamtumsatz' AS kpi_name,
    ROUND(SUM(order_sales)::numeric, 2)::text AS value
FROM order_details

UNION ALL

SELECT
    'Gesamtgewinn',
    ROUND(SUM(order_profits)::numeric, 2)::text
FROM order_details

UNION ALL

SELECT
    'Gesamtgewinnmarge',
    ROUND(
        (SUM(order_profits) / NULLIF(SUM(order_sales), 0) * 100)::numeric,
        2
    )::text
FROM order_details

UNION ALL

SELECT
    'Durchschnittliche Rabattquote',
    ROUND(
        (AVG(order_discount) * 100)::numeric,
        2
    )::text
FROM order_details

UNION ALL

SELECT
    'Anteil profitabler Bestellpositionen',
    ROUND(
        (
            COUNT(CASE WHEN order_profits >= 0 THEN 1 END)::numeric
            / COUNT(*)
            * 100
        ),
        2
    )::text
FROM order_details;

-- ============================================================
-- DATEI: 04_joined_data\canonical_join.sql
-- ============================================================

/*
=====================================================
Unicorn-Projekt – Woche 4

Kanonische Reporting-Tabelle

Autor: Jesco J. Schnebel

Granularität:
Eine Zeile pro Bestellposition.

Zweck:
Verbindung der vier Unicorn-Tabellen zu einem breiten,
analysebereiten Datensatz auf Basis des Business Slice.
=====================================================
*/

SELECT
    -- order_details
    od.order_id,
    od.product_id,
    od.order_sales,
    od.order_discount,
    od.order_profits,
    od.order_profit_ratio,
    od.quantity,

    -- orders
    o.order_date,
    o.shipping_mode,
    o.shipping_region,
    o.shipping_state,
    o.shipping_country,

    -- customers
    c.customer_id,
    c.customer_name,
    c.customer_segment,

    -- product
    p.product_category,
    p.product_subcategory,
    p.product_name

FROM order_details od

JOIN orders o
    ON o.order_id = od.order_id

JOIN customers c
    ON c.customer_id = o.customer_id

JOIN product p
    ON p.product_id = od.product_id

WHERE o.order_date BETWEEN '2016-01-01' AND '2017-12-31';

-- ============================================================
-- DATEI: 04_joined_data\join_comparison.sql
-- ============================================================

/*
=====================================================
Unicorn-Projekt – Woche 4

Vergleich von INNER JOIN und LEFT JOIN

Autor: Jesco J. Schnebel

Zweck:
Prüfung, welche Datensätze durch den kanonischen
INNER JOIN nicht sichtbar werden.

Dabei wird untersucht:
1. Kunden ohne Bestellungen
2. Produkte, die nie bestellt wurden
3. Bestellungen ohne Bestellpositionen
=====================================================
*/


-- ============================================================
-- VERGLEICH 1: Kunden ohne Bestellungen
-- Zweck:
-- Prüfen, ob Kunden existieren, denen keine Bestellung
-- zugeordnet werden kann.
-- ============================================================

SELECT
    COUNT(*) AS customers_with_no_orders
FROM customers c
LEFT JOIN orders o
    ON o.customer_id = c.customer_id
WHERE o.order_id IS NULL;


-- ============================================================
-- VERGLEICH 2: Produkte, die nie bestellt wurden
-- Zweck:
-- Prüfen, ob Produkte im Produktkatalog existieren,
-- die in keiner Bestellposition vorkommen.
-- ============================================================

SELECT
    COUNT(*) AS products_never_ordered
FROM product p
LEFT JOIN order_details od
    ON od.product_id = p.product_id
WHERE od.order_id IS NULL;


-- ============================================================
-- VERGLEICH 3: Bestellungen ohne Bestellpositionen
-- Zweck:
-- Prüfen, ob Bestellungen existieren,
-- denen keine Bestellposition zugeordnet ist.
-- ============================================================

SELECT
    COUNT(*) AS orders_with_no_items
FROM orders o
LEFT JOIN order_details od
    ON od.order_id = o.order_id
WHERE od.order_id IS NULL;

-- ============================================================
-- DATEI: 04_joined_data\join_validation.sql
-- ============================================================

-- =========================================
-- CHECK 1: Zeilenanzahl vor und nach dem Join
-- Zweck: Prüfen, ob durch den Join Zeilen verloren gehen
-- oder unerwartet vervielfacht werden.
-- Business Slice: 2016-01-01 bis 2017-12-31
-- Erwartetes Ergebnis: Beide Zeilenanzahlen sind identisch.
-- =========================================

-- CHECK 1a: Baseline im Business Slice
SELECT
    COUNT(*) AS baseline_rows
FROM order_details od
JOIN orders o
    ON o.order_id = od.order_id
WHERE o.order_date BETWEEN '2016-01-01' AND '2017-12-31';

-- ✅ CHECK 1a: 4.684 Zeilen vor dem Join.


-- CHECK 1b: Vollständiger kanonischer Join im Business Slice
SELECT
    COUNT(*) AS join_rows
FROM order_details od
JOIN orders o
    ON o.order_id = od.order_id
JOIN customers c
    ON c.customer_id = o.customer_id
JOIN product p
    ON p.product_id = od.product_id
WHERE o.order_date BETWEEN '2016-01-01' AND '2017-12-31';

-- ✅ CHECK 1b: 4.684 Zeilen nach dem Join.

-- ✅ CHECK 1 GESAMT bestanden:
-- Zeilenanzahl vor dem Join: 4.684
-- Zeilenanzahl nach dem Join: 4.684
-- Die Zeilenanzahlen sind identisch.
-- Durch den Join wurden keine Zeilen verloren oder vervielfacht.


-- =========================================
-- CHECK 2: Duplikaterkennung der Join-Schlüssel
-- Zweck: Prüfen, ob die Schlüssel auf der "1-Seite" eindeutig sind.
-- Erwartetes Ergebnis: 0 Zeilen.
-- =========================================

-- CHECK 2a: order_id in orders
SELECT
    order_id,
    COUNT(*) AS occurrences
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;

-- ✅ CHECK 2a bestanden: 0 Duplikate gefunden.


-- CHECK 2b: customer_id in customers
SELECT
    customer_id,
    COUNT(*) AS occurrences
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- ✅ CHECK 2b bestanden: 0 Duplikate gefunden.


-- CHECK 2c: product_id in product
SELECT
    product_id,
    COUNT(*) AS occurrences
FROM product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- ✅ CHECK 2c bestanden: 0 Duplikate gefunden.

-- =========================================
-- CHECK 3: Anti-Join für verwaiste Referenzen
-- Zweck: Prüfen, ob Fremdschlüssel in order_details
-- keinen passenden Datensatz in den verbundenen Tabellen finden.
-- Erwartetes Ergebnis: 0 verwaiste Referenzen.
-- =========================================

-- CHECK 3a: Bestellpositionen ohne passende Bestellung
SELECT
    COUNT(*) AS orphan_orders
FROM order_details od
LEFT JOIN orders o
    ON o.order_id = od.order_id
WHERE o.order_id IS NULL;

-- ✅ CHECK 3a bestanden: 0 verwaiste Bestellreferenzen.

-- CHECK 3b: Bestellungen der Positionen ohne passenden Kunden
SELECT
    COUNT(*) AS orphan_customers
FROM order_details od
JOIN orders o
    ON o.order_id = od.order_id
LEFT JOIN customers c
    ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL;

-- ✅ CHECK 3b bestanden: 0 verwaiste Kundenreferenzen.

-- CHECK 3c: Bestellpositionen ohne passendes Produkt
SELECT
    COUNT(*) AS orphan_products
FROM order_details od
LEFT JOIN product p
    ON p.product_id = od.product_id
WHERE p.product_id IS NULL;

-- ✅ CHECK 3c bestanden: 0 verwaiste Produktreferenzen.

-- ============================================================
-- DATEI: 05_cleaned_dimensions\cleaning.sql
-- ============================================================

-- =========================================
-- Sprint 5 — Bereinigung der Unicorn-Dimensionen
-- Basierend auf den Ergebnissen aus diagnostic_queries.sql
-- =========================================


-- =========================================
-- SPALTE: shipping_postal_code
-- Befund: 6 NULL-Werte
-- =========================================

-- Finding:
-- Alle 6 fehlenden Postleitzahlen gehören zu Burlington, Vermont.
-- In den vorhandenen Daten gibt es für Burlington, Vermont
-- keine einzige Bestellung mit eingetragener Postleitzahl.

-- Decision:
-- Die fehlenden Werte werden nicht durch eine erfundene
-- Postleitzahl ersetzt.
-- Die NULL-Werte bleiben erhalten, da keine zuverlässige
-- Postleitzahl aus den vorhandenen Daten abgeleitet werden kann.
-- Die fehlenden Werte werden über eine Flag-Spalte gekennzeichnet.

SELECT
    order_id,
    shipping_city,
    shipping_state,
    shipping_postal_code,
    CASE
        WHEN shipping_postal_code IS NULL THEN 1
        ELSE 0
    END AS postal_code_missing_flag
FROM
    orders;


-- =========================================
-- SPALTE: product_manufacturer
-- Befund: 9 verdächtige Herstellerwerte
-- =========================================

-- Finding:
-- 9 Datensätze enthalten offensichtlich verdächtige Herstellerwerte.
-- Bei diesen Datensätzen ist product_manufacturer identisch
-- mit product_name.
--
-- Beispiele:
-- 3-ring staple pack
-- Easy-staple paper
-- Staple envelope
-- Staple holder
-- Staple magnet
--
-- Der tatsächliche Hersteller kann aus den vorhandenen Daten
-- nicht zuverlässig bestimmt werden.

-- Decision:
-- Keine automatische Ersetzung durch einen Herstellernamen,
-- da dies nicht durch die Quelldaten belegt werden kann.
-- Die betroffenen Datensätze werden stattdessen über eine
-- Qualitäts-Flag-Spalte als verdächtig gekennzeichnet.

SELECT
    product_id,
    product_name,
    product_manufacturer,
    CASE
        WHEN product_manufacturer LIKE '%Staple%'
          OR product_manufacturer LIKE '%staple%'
          OR product_manufacturer LIKE 'Easy-%'
          OR product_manufacturer LIKE '3-ring%'
        THEN 'verdächtig'
        ELSE 'ok'
    END AS manufacturer_quality_flag
FROM
    product;

-- ============================================================
-- DATEI: 05_cleaned_dimensions\diagnostic_queries.sql
-- ============================================================

-- =========================================
-- Sprint 5 — Bereinigung der Unicorn-Dimensionen
-- Diagnoseabfragen
-- =========================================


-- SPALTE: customer_name
-- Prüfung: Führende oder nachgestellte Leerzeichen
-- Ergebnis: 0 Zeilen — keine Bereinigung erforderlich.

SELECT
    customer_name
FROM
    customers
WHERE
    customer_name <> TRIM(customer_name);


-- Prüfung: Groß-/Kleinschreibung mit INITCAP
-- Ergebnis: 36 Zeilen unterscheiden sich von INITCAP.
-- Die meisten Unterschiede sind jedoch korrekte Namen
-- (z. B. McCarthy, DeCherney, MaryBeth).
-- INITCAP darf daher NICHT pauschal angewendet werden.
-- Mögliche echte Schreibfehler: Dean percer, Dorris liebe.

SELECT
    customer_name,
    INITCAP(customer_name) AS initcap_version
FROM
    customers
WHERE
    customer_name <> INITCAP(customer_name);


-- Prüfung: Gezielt auffällige Schreibweisen in customer_name
-- Ergebnis: 2 Namen mit wahrscheinlich fehlerhafter
-- Groß-/Kleinschreibung gefunden: Dean percer und Dorris liebe.
-- Eine pauschale Anwendung von INITCAP ist trotzdem nicht zulässig.

SELECT
    customer_name
FROM
    customers
WHERE
    customer_name IN ('Dean percer', 'Dorris liebe');


-- SPALTE: customer_segment
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: Consumer (410), Corporate (237), Home Office (148)
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    customer_segment,
    COUNT(*) AS anzahl
FROM
    customers
GROUP BY
    customer_segment
ORDER BY
    customer_segment;


-- SPALTE: shipping_city
-- Prüfung: Führende oder nachgestellte Leerzeichen
-- Ergebnis: 0 Zeilen — keine Bereinigung erforderlich.

SELECT
    shipping_city
FROM
    orders
WHERE
    shipping_city <> TRIM(shipping_city);


-- Prüfung: Groß-/Kleinschreibung mit INITCAP
-- Ergebnis: 0 Zeilen — Schreibweise ist einheitlich.
-- Keine Bereinigung erforderlich.

SELECT
    shipping_city,
    INITCAP(shipping_city) AS initcap_version
FROM
    orders
WHERE
    shipping_city <> INITCAP(shipping_city);


-- SPALTE: shipping_state
-- Prüfung: Führende oder nachgestellte Leerzeichen
-- Ergebnis: 0 Zeilen — keine Bereinigung erforderlich.

SELECT
    shipping_state
FROM
    orders
WHERE
    shipping_state <> TRIM(shipping_state);


-- Prüfung: Groß-/Kleinschreibung mit INITCAP
-- Ergebnis: 4 Zeilen unterscheiden sich von INITCAP.
-- Alle Treffer enthalten "District of Columbia".
-- Die vorhandene Schreibweise ist korrekt; INITCAP würde daraus
-- fälschlicherweise "District Of Columbia" machen.
-- Keine Bereinigung erforderlich.

SELECT
    shipping_state,
    INITCAP(shipping_state) AS initcap_version
FROM
    orders
WHERE
    shipping_state <> INITCAP(shipping_state);


-- SPALTE: shipping_region
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: Central (1175), East (1405), South (822), West (1611)
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    shipping_region,
    COUNT(*) AS anzahl
FROM
    orders
GROUP BY
    shipping_region
ORDER BY
    shipping_region;


-- SPALTE: shipping_country
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: United States (5013)
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    shipping_country,
    COUNT(*) AS anzahl
FROM
    orders
GROUP BY
    shipping_country
ORDER BY
    shipping_country;


-- SPALTE: shipping_postal_code
-- Prüfung: Fehlende Werte (NULL)
-- Ergebnis: 6 Zeilen enthalten keine Postleitzahl.
-- Bereinigung bzw. Umgang mit den fehlenden Werten erforderlich.

SELECT
    COUNT(*) AS anzahl_null
FROM
    orders
WHERE
    shipping_postal_code IS NULL;


-- Prüfung: Welche Bestellungen enthalten keine Postleitzahl?
-- Ergebnis: Alle 6 NULL-Werte gehören zu Burlington, Vermont.
-- Damit wird geprüft, ob sich ein gemeinsames Muster erkennen lässt.

SELECT
    order_id,
    shipping_city,
    shipping_state,
    shipping_postal_code
FROM
    orders
WHERE
    shipping_postal_code IS NULL;


-- Prüfung: Gibt es für Burlington, Vermont eine vorhandene
-- Postleitzahl, aus der die fehlenden Werte abgeleitet werden könnten?
-- Ergebnis: 6 Bestellungen insgesamt, davon 0 mit Postleitzahl.
-- Eine zuverlässige Postleitzahl kann deshalb nicht aus den
-- vorhandenen Daten abgeleitet werden.

SELECT
    shipping_city,
    shipping_state,
    COUNT(*) AS anzahl_gesamt,
    COUNT(shipping_postal_code) AS anzahl_mit_postleitzahl
FROM
    orders
WHERE
    shipping_city = 'Burlington'
    AND shipping_state = 'Vermont'
GROUP BY
    shipping_city,
    shipping_state;


-- SPALTE: shipping_mode
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: First Class (787), Same Day (265),
-- Second Class (964), Standard Class (2997)
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    shipping_mode,
    COUNT(*) AS anzahl
FROM
    orders
GROUP BY
    shipping_mode
ORDER BY
    shipping_mode;


-- SPALTE: product_category
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: Furniture (380), Office Supplies (1058), Technology (412)
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    product_category,
    COUNT(*) AS anzahl
FROM
    product
GROUP BY
    product_category
ORDER BY
    product_category;


-- SPALTE: product_subcategory
-- Prüfung: Unterschiedliche Kategorien und deren Anzahl
-- Ergebnis: 17 einheitlich geschriebene Unterkategorien.
-- Keine inkonsistenten Kategorien gefunden.
-- Keine Bereinigung erforderlich.

SELECT
    product_subcategory,
    COUNT(*) AS anzahl
FROM
    product
GROUP BY
    product_subcategory
ORDER BY
    product_subcategory;


-- SPALTE: product_manufacturer

-- Prüfung: Suche nach verdächtigen Herstellerwerten,
-- die eher wie Produktbezeichnungen als wie Hersteller aussehen.
-- Ergebnis: 9 verdächtige Datensätze gefunden.
-- Bei diesen Datensätzen ist product_manufacturer identisch
-- mit product_name.
-- Diese Werte werden nicht automatisch geändert,
-- sondern für die weitere Bereinigung gekennzeichnet.

SELECT
    product_id,
    product_name,
    product_manufacturer
FROM
    product
WHERE
    product_manufacturer LIKE '%Staple%'
    OR product_manufacturer LIKE '%staple%'
    OR product_manufacturer LIKE 'Easy-%'
    OR product_manufacturer LIKE '3-ring%'
ORDER BY
    product_manufacturer;


-- Prüfung: Anzahl unterschiedlicher Herstellerwerte
-- Ergebnis: 183 unterschiedliche Herstellerwerte.

SELECT
    COUNT(DISTINCT product_manufacturer) AS anzahl_hersteller
FROM
    product;


-- Prüfung: NULL-Werte in product_manufacturer
-- Ergebnis: 0 NULL-Werte.
-- Keine Bereinigung aufgrund fehlender Herstellerwerte erforderlich.

SELECT
    COUNT(*) AS anzahl_null
FROM
    product
WHERE
    product_manufacturer IS NULL;


-- BEFUND: product_manufacturer
-- Insgesamt wurden 183 unterschiedliche Herstellerwerte gefunden.
-- Es gibt keine NULL-Werte in product_manufacturer.
-- 9 Datensätze enthalten jedoch verdächtige Werte, die eher wie
-- Produktbezeichnungen als wie tatsächliche Herstellernamen aussehen.
-- Beispiele: "3-ring staple pack", "Easy-staple paper",
-- "Staple envelope", "Staple magnet" und "Staple remover".
--
-- Entscheidung:
-- Die verdächtigen Werte werden nicht automatisch korrigiert,
-- da der tatsächliche Hersteller aus diesen Daten nicht sicher
-- bestimmt werden kann. Eine automatische Ersetzung würde daher
-- möglicherweise falsche Informationen erzeugen.
-- Die betroffenen Datensätze sollen stattdessen in cleaning.sql
-- als verdächtig gekennzeichnet werden.

-- ============================================================
-- DATEI: 05_cleaned_dimensions\rules_and_qa.sql
-- ============================================================

-- =========================================
-- Sprint 5 — Regelbasierte Standardisierung und QA
-- =========================================


-- =========================================
-- BUCKETING: product_subcategory
-- =========================================

-- Ziel:
-- Die 17 granularen product_subcategory-Werte werden in vier
-- fachlich verständliche Business-Buckets zusammengefasst.
--
-- Die Buckets ermöglichen eine übersichtlichere Auswertung
-- im Management-Dashboard und erleichtern beispielsweise
-- den Vergleich von Schreibwaren, Technik, Arbeitsplatz-
-- Materialien und Möbeln.
--
-- Alle 17 vorhandenen Unterkategorien wurden geprüft.
-- Aktuelles Ergebnis: 0 Produkte landen im Sicherheitsnetz 'Other'.

SELECT
    product_id,
    product_category,
    product_subcategory,
    CASE
        WHEN product_subcategory IN (
            'Paper',
            'Binders',
            'Envelopes',
            'Labels',
            'Fasteners'
        )
        THEN 'Writing & Filing'

        WHEN product_subcategory IN (
            'Phones',
            'Accessories',
            'Machines',
            'Copiers'
        )
        THEN 'Tech Hardware'

        WHEN product_subcategory IN (
            'Appliances',
            'Art',
            'Supplies',
            'Storage'
        )
        THEN 'Workspace Supplies'

        WHEN product_subcategory IN (
            'Chairs',
            'Tables',
            'Bookcases',
            'Furnishings'
        )
        THEN 'Furniture'

        ELSE 'Other'
    END AS product_bucket
FROM
    product;


-- =========================================
-- ASSERTION: Jede Produkt-Unterkategorie hat einen bekannten Bucket
-- Erwartetes Ergebnis: 0 Zeilen
-- Bei Abweichung: Eine neue oder unbekannte Unterkategorie ist vorhanden.
-- Die Bucketing-Regel muss geprüft und ggf. erweitert werden.
-- =========================================

SELECT
    product_subcategory,
    COUNT(*) AS nicht_zugeordnete_produkte
FROM
    product
WHERE
    product_subcategory NOT IN (
        'Paper',
        'Binders',
        'Envelopes',
        'Labels',
        'Fasteners',
        'Phones',
        'Accessories',
        'Machines',
        'Copiers',
        'Appliances',
        'Art',
        'Supplies',
        'Storage',
        'Chairs',
        'Tables',
        'Bookcases',
        'Furnishings'
    )
GROUP BY
    product_subcategory;


-- =========================================
-- ASSERTION: shipping_region enthält nur bekannte Regionen
-- Erwartetes Ergebnis: 0 Zeilen
-- Bei Abweichung: Eine neue oder unbekannte Region ist vorhanden.
-- Die Datenquelle und die erlaubten Regionswerte müssen geprüft werden.
-- =========================================

SELECT DISTINCT
    shipping_region
FROM
    orders
WHERE
    shipping_region NOT IN (
        'Central',
        'East',
        'South',
        'West'
    );


-- =========================================
-- ASSERTION: Anzahl fehlender Postleitzahlen bleibt unverändert
-- Erwartetes Ergebnis: 6
-- Bei Abweichung: Die Anzahl der NULL-Werte hat sich verändert.
-- Die Datenqualität von shipping_postal_code muss erneut geprüft werden.
-- =========================================

SELECT
    COUNT(*) AS anzahl_fehlende_postleitzahlen
FROM
    orders
WHERE
    shipping_postal_code IS NULL;



-- ============================================================
-- DATEI: 06_reporting_stack\parameterized_stack.sql
-- ============================================================

-- ============================================================
-- Unicorn-Projekt – Woche 6 Reporting Stack
--
-- Zweck:
-- Erzeugt zentrale KPI-Auswertungen zur Profitabilität
-- der Unicorn-Produktkategorien für den Business Slice
-- vom 01.01.2016 bis 31.12.2017.
--
-- Ebenen:
--   1. base          – bereinigter Canonical 4-Table-Join
--   2. per_category  – Aggregate pro Produktkategorie
--   3. final SELECT  – finale KPIs und Kennzahlen
--
-- Datenquellen:
--   customers, orders, order_details, product
--
-- Grain:
--   base          – eine Zeile pro Bestellposition
--   per_category  – eine Zeile pro Produktkategorie
--
-- Autor: Jesco J. Schnebel
-- ============================================================

-- ------------------------------------------------------------
-- LAYER 1: base – Bereinigte Basisdaten
-- Grain: eine Zeile pro Bestellposition
-- Join: order_details → orders → customers → product
-- Cleaning:
--   - Fehlende Postleitzahlen bleiben NULL und werden markiert
--   - Verdächtige Herstellerwerte werden per Flag gekennzeichnet
-- ------------------------------------------------------------

-- ------------------------------------------------------------
-- PARAMETERS – Steuerung des auszuwertenden Datenausschnitts
-- Datumswerte: gewünschter Start- und Endzeitpunkt
-- Region: 'all', 'Central', 'East', 'South' oder 'West'
-- Segment: 'all', 'Consumer', 'Corporate' oder 'Home Office'
-- Standardwerte entsprechen dem ursprünglichen Reporting Stack.
-- ------------------------------------------------------------
WITH parameters AS (
    SELECT
        DATE '2016-01-01' AS start_date,
        DATE '2017-12-31' AS end_date,
        'all' AS region_filter,
        'all' AS segment_filter
),

base AS (
    SELECT
        -- order_details
        od.order_id,
        od.product_id,
        od.order_sales,
        od.order_discount,
        od.order_profits,
        od.order_profit_ratio,
        od.quantity,

        -- orders
        o.order_date,
        o.shipping_mode,
        o.shipping_region,
        o.shipping_state,
        o.shipping_country,
        o.shipping_postal_code,
        -- NULL bleibt erhalten, da für Burlington (VT) kein belastbarer
        -- Ersatzwert im Datensatz vorhanden ist.
        CASE
            WHEN o.shipping_postal_code IS NULL THEN 1
            ELSE 0
        END AS postal_code_missing_flag,

        -- customers
        c.customer_id,
        c.customer_name,
        c.customer_segment,

        -- product
        p.product_category,
        p.product_subcategory,
        p.product_name,
        p.product_manufacturer,
        -- Verdächtige Herstellerwerte werden nicht ersetzt,
        -- da der tatsächliche Hersteller nicht eindeutig bestimmbar ist.
        CASE
            WHEN p.product_manufacturer LIKE '%Staple%'
              OR p.product_manufacturer LIKE '%staple%'
              OR p.product_manufacturer LIKE 'Easy-%'
              OR p.product_manufacturer LIKE '3-ring%'
            THEN 'verdächtig'
            ELSE 'ok'
        END AS manufacturer_quality_flag

    FROM order_details od

    JOIN orders o
        ON o.order_id = od.order_id

    JOIN customers c
        ON c.customer_id = o.customer_id

    JOIN product p
        ON p.product_id = od.product_id
    
    CROSS JOIN parameters prm

    WHERE o.order_date BETWEEN prm.start_date AND prm.end_date
          AND (
            prm.region_filter = 'all'
            OR o.shipping_region = prm.region_filter
          )
          AND (
            prm.segment_filter = 'all'
            OR c.customer_segment = prm.segment_filter
          )
),

-- ------------------------------------------------------------
-- LAYER 2: per_category – Aggregate pro Produktkategorie
-- Grain: eine Zeile pro Produktkategorie
-- Berechnet: Umsatz, Gewinn, durchschnittlichen Rabatt
--            sowie Anzahl aller und profitabler Positionen
-- ------------------------------------------------------------

per_category AS (
    SELECT
        product_category,
        SUM(order_sales) AS revenue,
        SUM(order_profits) AS profit,
        AVG(order_discount) AS avg_discount,
        COUNT(*) AS total_positions,
        COUNT(CASE WHEN order_profits >= 0 THEN 1 END) AS profitable_positions
    FROM base
    GROUP BY
        product_category
)

-- ------------------------------------------------------------
-- LAYER 3: final SELECT – Finale KPI-Ausgabe
-- Grain: eine Zeile pro Produktkategorie
-- Berechnet: Gewinnmarge, durchschnittliche Rabattquote
--            und Anteil profitabler Bestellpositionen
-- ------------------------------------------------------------

SELECT
    product_category,
    revenue,
    profit,

    -- NULLIF verhindert eine Division durch 0 bei fehlendem Umsatz.
    ROUND(
        (profit / NULLIF(revenue, 0) * 100)::numeric,
        2
    ) AS profit_margin,

    ROUND(
        (avg_discount * 100)::numeric,
        2
    ) AS avg_discount_percent,

    -- NULLIF verhindert eine Division durch 0 bei leeren Kategorien.
    ROUND(
        (
            profitable_positions::numeric
            / NULLIF(total_positions, 0)
            * 100
        ),
        2
    ) AS profitable_positions_percent

FROM
    per_category

ORDER BY
    revenue DESC;

-- ============================================================
-- DATEI: 06_reporting_stack\stack.sql
-- ============================================================

-- ============================================================
-- Unicorn-Projekt – Woche 6 Reporting Stack
--
-- Zweck:
-- Erzeugt zentrale KPI-Auswertungen zur Profitabilität
-- der Unicorn-Produktkategorien für den Business Slice
-- vom 01.01.2016 bis 31.12.2017.
--
-- Ebenen:
--   1. base          – bereinigter Canonical 4-Table-Join
--   2. per_category  – Aggregate pro Produktkategorie
--   3. final SELECT  – finale KPIs und Kennzahlen
--
-- Datenquellen:
--   customers, orders, order_details, product
--
-- Grain:
--   base          – eine Zeile pro Bestellposition
--   per_category  – eine Zeile pro Produktkategorie
--
-- Autor: Jesco J. Schnebel
-- ============================================================

-- ------------------------------------------------------------
-- LAYER 1: base – Bereinigte Basisdaten
-- Grain: eine Zeile pro Bestellposition
-- Join: order_details → orders → customers → product
-- Cleaning:
--   - Fehlende Postleitzahlen bleiben NULL und werden markiert
--   - Verdächtige Herstellerwerte werden per Flag gekennzeichnet
-- ------------------------------------------------------------

WITH base AS (
    SELECT
        -- order_details
        od.order_id,
        od.product_id,
        od.order_sales,
        od.order_discount,
        od.order_profits,
        od.order_profit_ratio,
        od.quantity,

        -- orders
        o.order_date,
        o.shipping_mode,
        o.shipping_region,
        o.shipping_state,
        o.shipping_country,
        o.shipping_postal_code,
        -- NULL bleibt erhalten, da für Burlington (VT) kein belastbarer
        -- Ersatzwert im Datensatz vorhanden ist.
        CASE
            WHEN o.shipping_postal_code IS NULL THEN 1
            ELSE 0
        END AS postal_code_missing_flag,

        -- customers
        c.customer_id,
        c.customer_name,
        c.customer_segment,

        -- product
        p.product_category,
        p.product_subcategory,
        p.product_name,
        p.product_manufacturer,
        -- Verdächtige Herstellerwerte werden nicht ersetzt,
        -- da der tatsächliche Hersteller nicht eindeutig bestimmbar ist.
        CASE
            WHEN p.product_manufacturer LIKE '%Staple%'
              OR p.product_manufacturer LIKE '%staple%'
              OR p.product_manufacturer LIKE 'Easy-%'
              OR p.product_manufacturer LIKE '3-ring%'
            THEN 'verdächtig'
            ELSE 'ok'
        END AS manufacturer_quality_flag

    FROM order_details od

    JOIN orders o
        ON o.order_id = od.order_id

    JOIN customers c
        ON c.customer_id = o.customer_id

    JOIN product p
        ON p.product_id = od.product_id

    WHERE o.order_date BETWEEN '2016-01-01' AND '2017-12-31'
),

-- ------------------------------------------------------------
-- LAYER 2: per_category – Aggregate pro Produktkategorie
-- Grain: eine Zeile pro Produktkategorie
-- Berechnet: Umsatz, Gewinn, durchschnittlichen Rabatt
--            sowie Anzahl aller und profitabler Positionen
-- ------------------------------------------------------------

per_category AS (
    SELECT
        product_category,
        SUM(order_sales) AS revenue,
        SUM(order_profits) AS profit,
        AVG(order_discount) AS avg_discount,
        COUNT(*) AS total_positions,
        COUNT(CASE WHEN order_profits >= 0 THEN 1 END) AS profitable_positions
    FROM base
    GROUP BY
        product_category
)

-- ------------------------------------------------------------
-- LAYER 3: final SELECT – Finale KPI-Ausgabe
-- Grain: eine Zeile pro Produktkategorie
-- Berechnet: Gewinnmarge, durchschnittliche Rabattquote
--            und Anteil profitabler Bestellpositionen
-- ------------------------------------------------------------

SELECT
    product_category,
    revenue,
    profit,

    -- NULLIF verhindert eine Division durch 0 bei fehlendem Umsatz.
    ROUND(
        (profit / NULLIF(revenue, 0) * 100)::numeric,
        2
    ) AS profit_margin,

    ROUND(
        (avg_discount * 100)::numeric,
        2
    ) AS avg_discount_percent,

    -- NULLIF verhindert eine Division durch 0 bei leeren Kategorien.
    ROUND(
        (
            profitable_positions::numeric
            / NULLIF(total_positions, 0)
            * 100
        ),
        2
    ) AS profitable_positions_percent

FROM
    per_category

ORDER BY
    revenue DESC;

-- ============================================================
-- DATEI: 07_analysis\stretch.sql
-- ============================================================

-- ============================================================
-- PROJEKTWOCHE 7 – STRETCH-ANALYSE
-- Datei: stretch.sql
--
-- Pfad:         A – Rolling 3-Month Average Revenue
-- Zweck:        Glättung der monatlichen Umsatzentwicklung
--               zur besseren Erkennung regionaler Trends.
-- Output:       192 Zeilen · 48 Monate × 4 Regionen
-- Granularität: Eine Zeile pro Monat und Region
--
-- Hinweis:
-- Die ersten beiden Monate jeder Region bleiben bewusst im
-- Ergebnis. Ihre Window Frames enthalten zunächst nur einen
-- bzw. zwei Monate; ab dem dritten Monat werden jeweils drei
-- Monate berücksichtigt.
--
-- Verantwortlich: Jesco-Joachim Schnebel
-- ============================================================

WITH monthly AS (

    -- --------------------------------------------------------
    -- CTE 1: Gesamtumsatz je Monat und Region
    -- --------------------------------------------------------
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS month_start,
        o.shipping_region,
        SUM(od.order_sales) AS month_revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    GROUP BY
        DATE_TRUNC('month', o.order_date),
        o.shipping_region
)

-- ------------------------------------------------------------
-- Finaler Output: Monatsumsatz und gleitender
-- 3-Monats-Durchschnitt innerhalb jeder Region
-- ------------------------------------------------------------
SELECT
    month_start,
    shipping_region,
    month_revenue,
    ROUND(
        AVG(month_revenue) OVER (
            PARTITION BY shipping_region
            ORDER BY month_start
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )::numeric,
        0
    ) AS rolling_3mo_avg
FROM monthly
ORDER BY
    shipping_region,
    month_start;

-- ============================================================
-- DATEI: 07_analysis\trend_and_ranking.sql
-- ============================================================

-- ============================================================
-- PROJEKTWOCHE 7 – TREND- UND RANKING-ANALYSE
-- Datei: trend_and_ranking.sql
--
-- Zweck:
-- Diese Datei enthält fortgeschrittene Analysen mit
-- Window Functions für das Unicorn-Projekt.
--
-- Inhalt:
-- 1. Top-3-Kunden pro Region nach Umsatz (2017–2018)
-- 2. Jahr-über-Jahr-Umsatzwachstum pro Region
--
-- Verantwortlich: Jesco-Joachim Schnebel
-- ============================================================


-- ============================================================
-- QUERY 1: TOP-3-KUNDEN PRO REGION NACH UMSATZ (2017–2018)
--
-- Output:       12 Zeilen · 4 Regionen × 3 Kunden
-- Granularität: Eine Zeile pro Kunde und Region
-- Methode:      ROW_NUMBER() innerhalb jeder Region
-- Zeitraum:     2017–2018
--
-- Hinweis:
-- Der Zeitraum wird vor dem Ranking gefiltert, damit nur
-- Umsätze aus 2017 und 2018 in die Rangfolge eingehen.
-- ROW_NUMBER() stellt genau drei Kunden je Region sicher.
-- ============================================================

WITH per_customer AS (

    -- --------------------------------------------------------
    -- CTE 1: Gesamtumsatz je Kunde und Region für 2017–2018
    -- --------------------------------------------------------
    SELECT
        o.shipping_region,
        o.customer_id,
        SUM(od.order_sales) AS customer_revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    WHERE o.order_date >= '2017-01-01'
    GROUP BY
        o.shipping_region,
        o.customer_id
),

ranked AS (

    -- --------------------------------------------------------
    -- CTE 2: Kunden innerhalb jeder Region nach Umsatz ranken
    -- --------------------------------------------------------
    SELECT
        shipping_region,
        customer_id,
        customer_revenue,
        ROW_NUMBER() OVER (
            PARTITION BY shipping_region
            ORDER BY customer_revenue DESC
        ) AS rank_in_region
    FROM per_customer
)

-- ------------------------------------------------------------
-- Finaler Output: nur die drei umsatzstärksten Kunden je Region
-- ------------------------------------------------------------
SELECT
    shipping_region,
    customer_id,
    customer_revenue,
    rank_in_region
FROM ranked
WHERE rank_in_region <= 3
ORDER BY
    shipping_region,
    rank_in_region;

-- ============================================================
-- QUERY 2: JAHR-ÜBER-JAHR-UMSATZWACHSTUM PRO REGION
--
-- Output:       16 Zeilen · 4 Regionen × 4 Jahre
-- Granularität: Eine Zeile pro Jahr und Region
-- Methode:      LAG() innerhalb jeder Region nach Jahr
--
-- Hinweis:
-- Das erste Jahr jeder Region hat keinen Vorjahreswert.
-- NULL bei 2015 ist deshalb korrekt und bleibt erhalten.
-- NULLIF schützt zusätzlich vor einer Division durch null.
-- ============================================================
--
-- Output:       16 Zeilen · 4 Regionen × 4 Jahre
-- Granularität: Eine Zeile pro Jahr und Region
-- Methode:      LAG() für den Vergleich mit dem Vorjahr
--
-- Hinweis:
-- Das erste Jahr jeder Region hat keinen Vorjahreswert.
-- NULL bei 2015 ist deshalb korrekt und bleibt erhalten.
-- NULLIF schützt zusätzlich vor einer Division durch null.
-- ============================================================

WITH per_region_year AS (

    -- --------------------------------------------------------
    -- CTE 1: Gesamtumsatz je Jahr und Region
    -- --------------------------------------------------------
    SELECT
        EXTRACT(YEAR FROM o.order_date)::int AS year,
        o.shipping_region,
        SUM(od.order_sales) AS revenue
    FROM orders o
    JOIN order_details od
        ON od.order_id = o.order_id
    GROUP BY
        EXTRACT(YEAR FROM o.order_date),
        o.shipping_region
),

with_prev AS (

    -- --------------------------------------------------------
    -- CTE 2: Vorjahresumsatz innerhalb derselben Region
    -- --------------------------------------------------------
    SELECT
        year,
        shipping_region,
        revenue,
        LAG(revenue) OVER (
            PARTITION BY shipping_region
            ORDER BY year
        ) AS prev_year_revenue
    FROM per_region_year
)

-- ------------------------------------------------------------
-- Finaler Output: Umsatz und prozentuale Veränderung zum Vorjahr
-- ------------------------------------------------------------
SELECT
    year,
    shipping_region,
    revenue,
    prev_year_revenue,
    ROUND(
        (
            100.0 * (revenue - prev_year_revenue)
            / NULLIF(prev_year_revenue, 0)
        )::numeric,
        1
    ) AS yoy_growth_pct
FROM with_prev
ORDER BY
    shipping_region,
    year;

-- ============================================================
-- DATEI: 08_delivery\final_queries.sql
-- ============================================================

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
