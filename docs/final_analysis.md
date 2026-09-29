# Unicorn-Umsatzanalyse — Abschlussbericht

**Analysezeitraum:** 2015–2018  
**Erstellt von:** Jesco-Joachim Schnebel  
**Erstellt am:** 05.09.2026

## Zusammenfassung

Die Umsatzanalyse für den Zeitraum 2015–2018 zeigt nach einem Rückgang im Jahr 2016 eine deutliche positive Entwicklung: 2017 stieg der Umsatz um 29,2 % und 2018 nochmals um 20,3 % auf 731.549. West war zwischen 2017 und 2018 mit einem Wachstum von 33,4 % die am stärksten wachsende Region. Gleichzeitig zeigt die Analyse des Rabattprogramms eine rechnerische Differenz von 569.573,69 beziehungsweise 19,80 % gegenüber einem hypothetischen Umsatz ohne Rabatte. Bei den Auftragspositionen mit negativem Gewinn weist Furniture mit -60.914 den höchsten aufsummierten negativen Gewinn auf.

## Zentrale Handlungsempfehlung

Das Rabattprogramm sollte gezielt auf seine Profitabilität überprüft werden. Im ersten Schritt sollte untersucht werden, ob und in welchem Umfang rabattierte Verkäufe im Bereich Furniture zu den negativen Ergebnissen beitragen. Erst auf Grundlage dieser Prüfung sollte entschieden werden, ob Rabatte in dieser Produktkategorie angepasst oder eingeschränkt werden. Damit wird vermieden, das weiterhin starke Umsatzwachstum durch vorschnelle Änderungen am Rabattprogramm zu gefährden.


## Q1. Wie hoch ist der Gesamtumsatz pro Jahr und wie hoch ist die Wachstumsrate gegenüber dem Vorjahr?

### Kontext
Die Umsatzentwicklung über mehrere Jahre zeigt, ob das Unternehmen wächst und wie stabil diese Entwicklung ist.

**Abfrage:** siehe [final_queries.sql](../sql/final_queries.sql), Q1

### Ergebnis
Nach einem Umsatzrückgang von 5,4 % im Jahr 2016 entwickelte sich der Umsatz deutlich positiv. 2017 stieg er um 29,2 % und 2018 nochmals um 20,3 % auf 731.549.

### Belege

| Jahr | Umsatz | Wachstum zum Vorjahr |
|---|---:|---:|
| 2015 | 497.371 | – |
| 2016 | 470.425 | -5,4 % |
| 2017 | 607.904 | +29,2 % |
| 2018 | 731.549 | +20,3 % |

### Einschränkung
Die Jahresumsätze zeigen die Gesamtentwicklung, erklären aber nicht, welche Regionen, Kunden oder Produkte das Wachstum verursacht haben.


## Q2. Welche Region treibt das stärkste Wachstum in den Jahren 2017–2018 und um wie viel?

### Kontext
Die regionale Betrachtung zeigt, welche Märkte besonders stark zur positiven Umsatzentwicklung des Unternehmens beitragen.

**Abfrage:** siehe [final_queries.sql](../sql/final_queries.sql), Q2

### Ergebnis
West ist mit einem Umsatzwachstum von 33,4 % zwischen 2017 und 2018 die am schnellsten wachsende Region. South folgt mit 33,2 % nur knapp dahinter.

### Belege

| Region | Umsatz 2017 | Umsatz 2018 | Wachstum |
|---|---:|---:|---:|
| West | 187.498 | 250.058 | +33,4 % |
| South | 92.315 | 122.925 | +33,2 % |
| East | 180.657 | 211.469 | +17,1 % |
| Central | 147.434 | 147.097 | -0,2 % |

### Einschränkung
Die Wachstumsrate allein berücksichtigt nicht die unterschiedliche absolute Umsatzhöhe der Regionen. Außerdem basiert der Vergleich nur auf den Jahren 2017 und 2018.


## Q3. Wer sind innerhalb der am schnellsten wachsenden Region die Top-3-Kunden nach Umsatz in 2017–2018?

### Kontext
Nachdem West als am schnellsten wachsende Region identifiziert wurde, zeigt die Kundenanalyse, welche Kunden dort besonders stark zum Umsatz beitragen.

**Abfrage:** siehe [final_queries.sql](../sql/final_queries.sql), Q3

### Ergebnis
Raymond Buch ist mit einem Umsatz von 14.345 der mit Abstand umsatzstärkste Kunde in der Region West im Zeitraum 2017–2018. Edward Hooks und Jane Waco folgen mit 7.408 beziehungsweise 7.393.

### Belege

| Rang | Kunde | Umsatz |
|---:|---|---:|
| 1 | Raymond Buch | 14.345 |
| 2 | Edward Hooks | 7.408 |
| 3 | Jane Waco | 7.393 |

### Einschränkung
Die Rangfolge basiert ausschließlich auf dem Umsatz der Jahre 2017–2018 in der Region West. Sie berücksichtigt weder die Profitabilität der einzelnen Kunden noch deren Umsatzentwicklung innerhalb dieses Zeitraums.


## Q4. Welcher Anteil des Gesamtumsatzes geht durch das Rabattprogramm gegenüber einem hypothetischen Szenario ohne Rabatte verloren?

### Kontext
Die Gegenüberstellung des tatsächlichen Umsatzes mit einem hypothetischen Szenario ohne Rabatte zeigt, wie groß die rechnerische Umsatzdifferenz durch gewährte Rabatte ist.

**Abfrage:** siehe [final_queries.sql](../sql/final_queries.sql), Q4

### Ergebnis
Der tatsächliche Gesamtumsatz beträgt 2.307.249,00. Unter der Annahme unveränderter Absatzmengen hätte der Umsatz ohne Rabatte rechnerisch 2.876.822,69 betragen. Die Differenz beträgt damit 569.573,69 beziehungsweise 19,80 % des hypothetischen Umsatzes ohne Rabatte.

### Belege

| Kennzahl | Wert |
|---|---:|
| Tatsächlicher Umsatz | 2.307.249,00 |
| Hypothetischer Umsatz ohne Rabatte | 2.876.822,69 |
| Rechnerische Umsatzdifferenz | 569.573,69 |
| Anteil am hypothetischen Umsatz | 19,80 % |

### Einschränkung
Die Berechnung unterstellt, dass ohne Rabatte dieselben Mengen verkauft worden wären. Sie zeigt deshalb eine hypothetische Umsatzdifferenz und keinen nachgewiesenen tatsächlichen Umsatzverlust.


## Q5. Welche Produktkategorien tragen die Auftragspositionen mit negativem Gewinn am stärksten?

### Kontext
Die Analyse der Auftragspositionen mit negativem Gewinn zeigt, in welchen Produktkategorien sich die größten negativen Ergebnisbeiträge konzentrieren.

**Abfrage:** siehe [final_queries.sql](../sql/final_queries.sql), Q5

### Ergebnis
Furniture weist mit -60.914 den höchsten gesamten negativen Gewinn auf. Office Supplies hat zwar mit 884 die meisten Auftragspositionen mit negativem Gewinn, deren gesamter negativer Gewinn liegt mit -56.637 jedoch etwas unter dem von Furniture.

### Belege

| Produktkategorie | Auftragspositionen mit negativem Gewinn | Gesamter negativer Gewinn |
|---|---:|---:|
| Furniture | 712 | -60.914 |
| Office Supplies | 884 | -56.637 |
| Technology | 268 | -38.575 |

### Einschränkung
Die Analyse betrachtet ausschließlich Auftragspositionen mit negativem Gewinn. Sie zeigt daher nicht, wie profitabel die jeweilige Produktkategorie insgesamt ist und wodurch die negativen Ergebnisse verursacht wurden.


## Q6. Welche zentrale Handlungsempfehlung ergibt sich aus der Analyse für die Geschäftsführung?

### Kontext

Die Ergebnisse zeigen einerseits ein starkes Umsatzwachstum in den Jahren 2017 und 2018, andererseits aber auch eine erhebliche rechnerische Umsatzdifferenz durch Rabatte sowie negative Ergebnisbeiträge einzelner Produktkategorien.

**Abfrage:** Q6 ergänzt die Ergebnisse aus Q1–Q5 um eine gezielte Analyse der Profitabilität der Kategorie Furniture nach Rabattgruppe.

### Empfehlung

Das Rabattprogramm sollte gezielt auf seine Profitabilität überprüft werden. Insbesondere im Bereich Furniture sollte geprüft werden, ob hohe Rabatte wirtschaftlich sinnvoll sind und unter welchen Bedingungen sie eingesetzt werden sollten.

### Belege

- Der Gesamtumsatz stieg 2018 um 20,3 % auf 731.549.
- West war 2017–2018 mit 33,4 % die am stärksten wachsende Region.
- Die rechnerische Differenz zum hypothetischen Umsatz ohne Rabatte beträgt 569.573,69 beziehungsweise 19,80 %.
- Furniture weist mit -60.914 den höchsten aufsummierten negativen Gewinn aus den betrachteten Verlustpositionen auf.
- Die ergänzende Analyse von Furniture nach Rabattgruppe zeigt einen deutlichen Unterschied in der Profitabilität: Ohne Rabatt beträgt die Gewinnmarge 22,69 %, bei 21–30 % Rabatt -10,77 % und bei über 30 % Rabatt -45,76 %.

### Einschränkung

Die Analyse zeigt einen deutlichen Zusammenhang zwischen höheren Rabattgruppen und einer niedrigeren Profitabilität innerhalb der Kategorie Furniture. Daraus lässt sich jedoch kein ursächlicher Zusammenhang ableiten. Weitere Einflussfaktoren wie Produkte, Mengen, Kundensegmente oder Verkaufsbedingungen können ebenfalls eine Rolle spielen. Eine Änderung des Rabattprogramms sollte deshalb auf Basis einer weiterführenden Ursachenanalyse erfolgen.


