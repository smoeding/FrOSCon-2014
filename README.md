# Datenanalyse mit R für Administratoren - Beispiele aus der Praxis

Slides (in German) and code for my presentation at FrOSCon 2014.

If you just want the slides: https://github.com/smoeding/FrOSCon-2014/blob/master/R4Admins.pdf

## Zusammenfassung

R, die freie Programmiersprache für statistisches Rechnen und Grafiken, ist auch für Administratoren ein nützliches Werkzeug. Dieser Vortrag beginnt mit einer kurzen Vorstellung von R und zeigt dann an einigen Beispielen, wie R sich für die Analyse von Performance-Daten nutzen lässt oder damit eine Prognose der zukünftigen Auslastung eines Systems sowie der Skalierbarkeit abgeleitet werden kann.

## Beschreibung

Analysen und Auswertungen gehören zum IT-Alltag: die Antwortzeiten einer Applikation müssen bezüglich der SLA-Ziele geprüft werden, ein Benchmark soll die Skalierbarkeit einer neuen Plattform nachweisen und irgendjemand benötigt für seine Präsentation noch eine informative Grafik.

R, die freie Programmierumgebung für statistisches Rechnen und Grafiken, ist ein leistungsfähiges Werkzeug zur Datenanalyse und grafischen Aufbereitung, mit der sich solche Aufgaben mühelos erledigen lassen.

Denn auch ohne umfassende mathematische Kenntnisse lassen sich aus den Daten eines Logfiles quantitative Aussagen ableiten oder Messwerte veranschaulichen. Dieser Vortrag stellt dazu einige Beispiele vor.

So können hochwertige Grafiken schon mit einfachen Aufrufen erstellt werden und müssen bei einer Aktualisierung der Daten im Gegensatz zu vielen (mausbedienten) Tools auch nicht mühsam wieder neu zusammengebaut werden.

Mit gemessenen Performance-Daten lässt sich schließlich ein Modell zur Skalierbarkeit eines Systems erstellen. Dies kann nicht nur zur Vorhersage des maximal erreichbaren Durchsatzes genutzt werden, sondern erlaubt häufig außerdem Rückschlüsse auf das im System versteckte Bottleneck.

## Erstellung PDF

Es wird `knitr` verwendet, um die Präsentation *in einem Guss* zu erstellen. Die Generierung erfordert dabei in mehreren Schritten. Zunächst wird mit R aus dem *noweb* Format ein LaTeX-Dokument erstellt:

```R
library(knitr)
knit("R4Admins.Rnw")
```

Anschließend wird aus dem Ergebnis mit der vertrauten LaTeX-Sequenz das finale PDF-Dokument gebaut:

```
pdflatex R4Admins
bibtex R4Admins
pdflatex R4Admins
pdflatex R4Admins
```

Alternativ bietet sich der Einsatz von RStudio an, womit sich die komplette Sequenz (R + LaTeX) mit einem Kommando erledigen läßt.
