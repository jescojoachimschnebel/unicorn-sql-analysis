# Unicorn – Umsatz- und Profitabilitätsanalyse mit SQL

Analyse einer relationalen Beispieldatenbank: von der Prüfung der Datenqualität über Geschäftskennzahlen bis zur Untersuchung von Umsatzwachstum, Rabatten und Profitabilität.

**Autor:** Jesco-Joachim Schnebel · **Projektbewertung:** 95/100 Punkte  
**Technologien:** PostgreSQL, SQL · **Werkzeuge:** Beekeeper Studio, Visual Studio Code

## Schnellüberblick

- [Abschlussbericht](docs/final_analysis.md): Geschäftsfragen, Ergebnisse und Einschränkungen.
- [Finale SQL-Abfragen](sql/final_queries.sql): sechs Auswertungen zur Abschlussanalyse.
- [Gesamte SQL-Sammlung](sql/09_queries.sql): Exploration, Qualitätsprüfungen, Kennzahlen, Joins und Reporting.
- [Ergebnisexporte](docs/results/): dokumentierte Ausgaben der finalen Abfragen als CSV.

## Geschäftsfragen

1. Wie entwickeln sich Umsatz und jährliches Wachstum?
2. Welche Region hat von 2017 auf 2018 die höchste prozentuale Wachstumsrate?
3. Welche drei Kunden erzielen in der Region West 2017–2018 den höchsten Umsatz?
4. Wie groß ist die rechnerische Umsatzdifferenz zu einem Szenario ohne Rabatte?
5. In welchen Produktkategorien summieren sich die größten Verluste aus Bestellpositionen mit negativem Gewinn?
6. Wie unterscheidet sich die Profitabilität von Furniture nach Rabattgruppe, und welche weitere Prüfung lässt sich daraus ableiten?

## Ausgewählte Ergebnisse

Die Werte stammen aus den vorhandenen Ergebnisexporten und dem Abschlussbericht. Sie wurden für diese Portfolio-Aufbereitung nicht erneut gegen die Datenbank berechnet.

| Beobachtung | Ergebnis | Beleg |
| --- | --- | --- |
| Umsatzentwicklung 2018 | Umsatz 731.549; Wachstum zum Vorjahr **20,3 %** | [Jahresumsätze](docs/results/q1_revenue_by_year.csv) |
| Regionales Wachstum 2017–2018 | **West: 33,4 %**, gefolgt von South mit 33,2 % | [Regionenvergleich](docs/results/q2_region_growth.csv) |
| Hypothetisches Szenario ohne Rabatte | Rechnerische Differenz **569.573,69**, entsprechend **19,80 % des hypothetischen Umsatzes** | [Rabattanalyse](docs/results/q4_discount_impact.csv) |
| Furniture nach Rabattgruppe | Gewinnmarge ohne Rabatt **22,69 %**, bei über 30 % Rabatt **−45,76 %** | [Profitabilität](docs/results/q6_recommendation_evidence.csv) |

Umsatzbeträge sind in den Einheiten der Projektquelle angegeben; eine unbestätigte Währung wird nicht ergänzt.

**Fachliche Schlussfolgerung:** Das Rabattprogramm bei Furniture sollte gezielt auf Profitabilität und mögliche Einflussfaktoren untersucht werden. Die Auswertung zeigt einen Zusammenhang, belegt aber keine Kausalität. Das Szenario ohne Rabatte setzt unveränderte Absatzmengen voraus und ist kein Nachweis eines tatsächlich vermeidbaren Umsatzverlusts.

## Vorgehen und SQL-Kompetenzen

| Bereich | Umsetzung im Projekt |
| --- | --- |
| Datenqualität | NULL-Prüfungen, Duplikaterkennung, Wertebereiche und Prüfung verwaister Referenzen |
| Datenmodell und Joins | Verbindung von vier Tabellen; Vergleich von INNER JOIN und LEFT JOIN sowie Prüfung der Zeilenanzahl |
| Kennzahlen | Umsatz, Gewinn, Gewinnmarge, durchschnittlicher Rabatt und Anteil profitabler Bestellpositionen |
| Datenaufbereitung | CASE-basierte Gruppen und Qualitätsflags; fehlende Werte bleiben erhalten, wenn kein belastbarer Ersatz vorliegt |
| Reporting | Mehrstufige CTEs und Parameter für Zeitraum, Region und Kundensegment |
| Vertiefende Analyse | LAG für Vorjahresvergleiche, ROW_NUMBER für Rankings und gleitende Mittelwerte mit Window Functions |

## Datenbasis und Zeiträume

Die Unicorn-Beispieldatenbank besteht aus vier Tabellen:

- `customers`: Kunden und Kundensegmente
- `orders`: Bestellungen mit Datum und Versandinformationen
- `order_details`: Bestellpositionen mit Umsatz, Gewinn, Rabatt und Menge
- `product`: Produkte, Kategorien und Unterkategorien

Die Abschlussanalyse beschreibt den Datenbestand **2015–2018**. Der frühere Business Slice und die Standardparameter des Reporting Stacks beziehen sich auf **2016–2017**. Diese Auswertungszeiträume sind getrennt zu betrachten.

## Repository-Struktur

```text
unicorn-sql-analysis/
├── README.md
├── .gitignore
├── sql/
│   ├── README.md
│   ├── final_queries.sql
│   └── 09_queries.sql
└── docs/
    ├── final_analysis.md
    ├── results/                 # Sechs Ergebnisexporte, Q1–Q6
    ├── original_readme.md       # Dokumentation der ursprünglichen Abgabe
    └── portfolio_notes.md       # Herkunft, Umfang und technische Hinweise
```

## Ausführung und Reproduzierbarkeit

1. Eine PostgreSQL-Datenbank mit den vier Unicorn-Tabellen und den im SQL verwendeten Spalten bereitstellen. Datenbankexport, Tabellenanlage und Importskripte sind nicht Bestandteil dieses Repositorys.
2. Die Verbindung in einem SQL-Client öffnen, beispielsweise Beekeeper Studio. Die Tabellen müssen über den eingestellten Suchpfad erreichbar sein.
3. Die mit Q1–Q6 bezeichneten Abfragen aus [final_queries.sql](sql/final_queries.sql) einzeln ausführen und mit den [CSV-Ergebnissen](docs/results/) vergleichen.
4. Für den vollständigen Analyseweg die durch `DATEI:` gekennzeichneten Abschnitte in [09_queries.sql](sql/09_queries.sql) verwenden.

Die SQL-Dateien wurden unverändert übernommen. Die Gesamtdatei enthält auch die finalen Abfragen; beide Dateien müssen daher nicht nacheinander ausgeführt werden. Hinweise zu Datumsfiltern, Rankings und dem gleitenden Mittelwert stehen in den [technischen Notizen](docs/portfolio_notes.md).

## Projektkontext

Das Projekt entstand im Rahmen einer Weiterbildung in Data Analytics. Die Bewertung von **95/100 Punkten** bezieht sich auf die ursprüngliche Projektabgabe und wurde vom Autor mitgeteilt. Dieses Repository bereitet ausgewählte vorhandene Projektdateien für das Portfolio auf.
