# Herkunft und technische Hinweise

## Portfolio-Aufbereitung

Die Portfolio-Version basiert auf der vorhandenen README, der SQL-Gesamtdatei und ausgewählten Dateien aus `08_delivery` des ursprünglichen Projektordners.

- Beide SQL-Dateien und die sechs CSV-Dateien wurden unverändert übernommen.
- Der Abschlussbericht wurde übernommen; lediglich die Verweise auf die finale SQL-Datei wurden an den neuen Speicherort angepasst.
- `original_readme.md` bewahrt die ursprüngliche README unverändert. Ihre Strukturübersicht beschreibt die ursprüngliche Abgabe, nicht den Umfang dieses Repositorys.
- Haupt-README und Navigationshinweise wurden für das Portfolio neu verfasst.
- Weitere Begleitdokumente und die Präsentation sind nicht Bestandteil dieser Auswahl.

## Prüfumfang

Die Projektbeschreibung wurde mit dem SQL und den Berichts- und CSV-Inhalten abgeglichen. Die Kopierintegrität der unverändert übernommenen Dateien wurde anhand von SHA-256 geprüft. Eine erneute SQL-Ausführung oder vollständige fachliche Validierung gegen die Datenbank erfolgte nicht: Die vier Basistabellen sind hier nicht als Datenbank verfügbar.

## Hinweise zur Wiederverwendung

1. **Zeiträume:** Mehrere finale Abfragen verwenden den gesamten vorhandenen Datenbestand. Die Angabe 2015–2018 setzt daher den ursprünglichen Datenbestand voraus. Für erweiterte Datenbestände müssen Filter angepasst werden.
2. **Früheres Kundenranking:** Der Abschnitt `07_analysis/trend_and_ranking.sql` nennt 2017–2018, setzt aber nur eine Untergrenze ab 2017. Die finale Q3-Abfrage grenzt den Zeitraum dagegen bis vor 2019 ein.
3. **Region West:** Q3 verwendet West als feste Auswahl aus dem dokumentierten Q2-Ergebnis. Die Region wird nicht automatisch aus Q2 übernommen.
4. **Gleitender Mittelwert:** `ROWS BETWEEN 2 PRECEDING AND CURRENT ROW` mittelt bis zu drei vorhandene Monatszeilen. Nur bei lückenlos vorhandenen Monaten entspricht dies drei aufeinanderfolgenden Kalendermonaten.
5. **Ranking bei Gleichstand:** ROW_NUMBER begrenzt die Auswahl auf bis zu drei Kunden. Bei identischen Umsätzen ist ohne zusätzliches Sortierkriterium die Reihenfolge nicht eindeutig.
6. **Rabattanalyse:** Die Berechnung setzt unveränderte Mengen ohne Rabatt voraus. Bei 100 % Rabatt entsteht durch NULLIF ein NULL-Wert; bei anderen Datenbeständen ist dieser Sonderfall zu prüfen.
7. **Gewinninterpretation:** Q5 summiert ausschließlich negative Gewinne und zeigt nicht den Gesamtgewinn einer Kategorie.

Diese Hinweise dokumentieren Grenzen des vorhandenen SQL. Die bewerteten Abfragen wurden nicht stillschweigend verändert.
