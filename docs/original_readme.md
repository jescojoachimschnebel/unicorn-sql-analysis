# Unicorn-Projekt – SQL Data Exploration & Business Analysis

## Projektbeschreibung

Ziel dieses Projekts ist es, eine unbekannte relationale Datenbank systematisch zu analysieren, zu dokumentieren und als Grundlage für spätere Business-Analysen aufzubereiten.

Zu Beginn werden Tabellenstruktur, Grain, Primary Keys, Datenqualität und potenzielle Datenrisiken untersucht. Darauf aufbauend entstehen Business Slices, SQL-Analysen, KPI-Auswertungen, Datenbereinigungen und ein wiederverwendbarer Reporting Stack.
Die Ergebnisse der Analyse werden im finalen Abschlussbericht dokumentiert und zusätzlich in einer Präsentation für die abschließende Vorstellung und Diskussion aufbereitet.

## Hinweis zum Projektverlauf

Im Rahmen der frühen Projektphasen wurde die geforderte Datenprüfung und
Definition des Business Slice bewusst um zusätzliche explorative
Geschäftsanalysen erweitert.

Dabei wurden bereits Umsatz, Gewinn und Profitabilität nach Produktkategorien
und Unterkategorien sowie der Zusammenhang zwischen Rabatt und Profitabilität
untersucht. Diese Analysen gingen teilweise über die Mindestanforderungen der
jeweiligen Projektwoche hinaus.

Ziel dieser Erweiterung war es, den Datensatz nicht nur technisch zu prüfen,
sondern ihn wie in einem realen Analyseprojekt frühzeitig auf geschäftlich
relevante Zusammenhänge zu untersuchen.

Aus diesem Grund wurden einzelne Inhalte bereits früher bearbeitet, die in der
vorgegebenen Projektstruktur erst in späteren Wochen aufgegriffen werden.

---

## Projektziele

- Verständnis des Datenmodells entwickeln
- Tabellenstruktur dokumentieren
- Grain und Primary Keys identifizieren
- Datenqualität bewerten
- Datenrisiken dokumentieren
- Explorative SQL-Abfragen erstellen
- Business Slice für spätere Analysen definieren
- Grundlage für Business-Analysen schaffen
- Datenbereinigung nachvollziehbar dokumentieren
- Einen wiederverwendbaren und parametrisierbaren Reporting Stack entwickeln

---

## Projektstruktur

Unicorn-Projekt
│
├── 01_audit
│   ├── data_dictionary.md
│   ├── data_risks.md
│   ├── exploration.sql
│   └── grain_and_keys.md
│
├── 02_qa
│   ├── assertions.sql
│   ├── business_slice.sql
│   ├── qa_checks.sql
│   ├── qa_findings.md
│   └── slice_notes.md
│
├── 03_kpis
│   ├── individual_kpis.sql
│   ├── kpi_definitions.md
│   ├── segmented_kpis.sql
│   ├── summary_query.sql
│   └── summary_output.csv
│
├── 04_joined_data
│   ├── canonical_join.sql
│   ├── join_validation.sql
│   ├── validation_notes.md
│   ├── join_comparison.sql
│   └── join_comparison.md
│
├── 05_cleaned_dimensions
│   ├── diagnostic_queries.sql
│   ├── cleaning.sql
│   ├── rules_and_qa.sql
│   └── before_after.md
│
├── 06_reporting_stack
│   ├── stack.sql
│   ├── stack_notes.md
│   └── parameterized_stack.sql
│
├── 07_analysis
│   ├── explain_review.md
│   ├── stretch_notes.md
│   ├── stretch.sql
│   ├── trend_and_ranking_results.md
│   └── trend_and_ranking.sql
│
├── 08_delivery
│   ├── results
│   │   ├── q1_revenue_by_year.csv
│   │   ├── q2_region_growth.csv
│   │   ├── q3_top_customers_west.csv
│   │   ├── q4_discount_impact.csv
│   │   ├── q5_negative_profit_categories.csv
│   │   └── q6_recommendation_evidence.csv
│   ├── final_analysis.md
│   ├── final_queries.sql
│   ├── presentation.pptx
│   ├── README.md
│   └── self_assessment.md
│
├── 09_queries.sql
└── README.md


---

## Verwendete Werkzeuge

- SQL (PostgreSQL)
- Beekeeper Studio
- Visual Studio Code
- Markdown
- GitHub (optional)

---

## Datenbank

Verwendet wird die Unicorn-Datenbank, ein relationales Beispieldatenmodell mit den vier zentralen Tabellen:

- customers
- orders
- order_details
- product

---

## Dokumentation

Die Projektdokumentation besteht aus mehreren Bausteinen und folgt der Struktur des Projektordners.

### 01_audit

- **`data_dictionary.md`** – Beschreibung der Tabellen und Spalten
- **`data_risks.md`** – Dokumentation möglicher Datenrisiken
- **`exploration.sql`** – Explorative SQL-Abfragen
- **`grain_and_keys.md`** – Analyse von Granularität und Primärschlüsseln

### 02_qa

- **`assertions.sql`** – SQL-Assertions zur Überprüfung zentraler Datenannahmen
- **`business_slice.sql`** – Definition des Business Slice
- **`qa_checks.sql`** – SQL-Abfragen zur Überprüfung der Datenqualität
- **`qa_findings.md`** – Dokumentation der Ergebnisse der QA-Prüfungen
- **`slice_notes.md`** – Dokumentation der Filterentscheidungen

### 03_kpis

- **`individual_kpis.sql`** – Einzelberechnungen der definierten KPIs
- **`kpi_definitions.md`** – Definition und fachliche Beschreibung der verwendeten KPIs
- **`segmented_kpis.sql`** – Segmentierte KPI-Analysen und CASE-basierte Geschäftsregeln
- **`summary_output.csv`** – Export der KPI-Ergebnisse
- **`summary_query.sql`** – Zusammenführung der KPIs in einer Übersicht

### 04_joined_data

- **`canonical_join.sql`** – Kanonischer Join der vier zentralen Unicorn-Tabellen
- **`join_comparison.md`** – Interpretation des Vergleichs von `INNER JOIN` und `LEFT JOIN`
- **`join_comparison.sql`** – Vergleichende Analysen mit `LEFT JOIN`
- **`join_validation.sql`** – Technische Validierung des kanonischen Joins
- **`validation_notes.md`** – Dokumentierte Ergebnisse der Join-Validierung

### 05_cleaned_dimensions

- **`before_after.md`** – Gegenüberstellung der Datenqualität vor und nach den Cleaning-Entscheidungen
- **`cleaning.sql`** – Dokumentierte und nachvollziehbare Cleaning-Entscheidungen
- **`diagnostic_queries.sql`** – Diagnostische Prüfungen relevanter Dimensionsfelder
- **`rules_and_qa.sql`** – Regelbasierte Standardisierung von Produkt-Unterkategorien sowie QA-Assertions für Buckets, Regionen und fehlende Postleitzahlen

### 06_reporting_stack

- **`parameterized_stack.sql`** – Parametrisierte Variante des Reporting Stacks für Zeitraum, Region und Kundensegment
- **`stack_notes.md`** – Dokumentation von Aufbau, Designentscheidungen und bekannten Einschränkungen des Reporting Stacks
- **`stack.sql`** – CTE-basierter Reporting Stack für die zentralen KPI-Auswertungen

### 07_analysis

- `explain_review.md` – Dokumentation der EXPLAIN-Überprüfung und Bewertung der Abfrageausführung
- `stretch_notes.md` – Dokumentation der zusätzlichen Stretch-Analyse
- `stretch.sql` – Erweiterte SQL-Analyse über die Kernanforderungen hinaus
- `trend_and_ranking_results.md` – Dokumentation der Ergebnisse der Trend-, Wachstums- und Ranking-Analysen
- `trend_and_ranking.sql` – Analyse von Umsatztrends, regionalem Wachstum und Kunden-Rankings mithilfe von Window Functions

### 08_delivery

- **`results/`** – Exportierte Ergebnisdateien der finalen SQL-Abfragen
- **`final_analysis.md`** – Abschlussbericht mit den sechs Business-Fragen, Ergebnissen, Belegen, Einschränkungen und zentraler Handlungsempfehlung
- **`final_queries.sql`** – Finale und geprüfte SQL-Abfragen für die Business-Analyse
- **`presentation.pptx`** – Präsentation der wichtigsten Ergebnisse und der zentralen Handlungsempfehlung
- **`README.md`** – Übersicht der finalen Abgabe, der sechs Geschäftsfragen, der enthaltenen Dateien und der technischen Umgebung
- **`self_assessment.md`** – Selbsteinschätzung anhand der vorgegebenen Bewertungskriterien

### 09_queries.sql

- **`09_queries.sql`** – Zusammengeführte SQL-Abfragen des Projekts für die finale Abgabe und Reproduzierbarkeit

---

## Bearbeitungsstand

Die bisherigen Projektphasen wurden erfolgreich bearbeitet. Einzelne Inhalte
späterer Projektwochen wurden im Rahmen der erweiterten Analyse bereits
vorweggenommen und dokumentiert.

Aktueller Projektstand:

- `01_audit` – ✅ Datenstruktur, Data Dictionary, Granularität, Primärschlüssel und Datenrisiken analysiert und dokumentiert
- `02_qa` – ✅ Business Slice definiert sowie Datenqualität mit QA-Checks und Assertions überprüft
- `03_kpis` – ✅ KPI-Definitionen und KPI-Analysen erstellt
- `04_joined_data` – ✅ kanonischer Join, Validierung und Join-Vergleich erstellt
- `05_cleaned_dimensions` – ✅ Dimensionsprüfung und Cleaning-Entscheidungen abgeschlossen
- `06_reporting_stack` – ✅ Reporting Stack erstellt, dokumentiert und parametrisiert
- `07_analysis` – ✅ Trend-, Wachstums- und Ranking-Analysen abgeschlossen
- `08_delivery` – ✅ Abschlussbericht, finale SQL-Abfragen, sechs Ergebnisdateien, Selbsteinschätzung und Präsentation erstellt
- `09_queries.sql` – ✅ Sämtliche SQL-Abfragen des Projekts in einer Datei zusammengeführt

**Hinweis:** Der Bearbeitungsstand beschreibt die bereits erstellten
Projektartefakte und ist nicht mit dem aktuellen zeitlichen Stand des
Masterschool-Kursplans gleichzusetzen.

## Autor

Jesco-Joachim Schnebel

Data Analytics Reskilling
2026