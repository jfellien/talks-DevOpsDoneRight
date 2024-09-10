# DevOps done right

Dies ist ein Projekt, das ich benutze, um meinen Vortrag zum Thema, wie DevOps eigentlich gemeint ist, zu untermalen.

Es wird eine Asp.Net Core Web App im MVC Style in die Cloud deployed und dann im Laufe des Vortrages werden Änderungen an der Dahinterliegenden DB gemacht und ausgerollt. 

Als Deploymentmittel verwende ich bicep und Azure Pipelines.

# Deployment

Zum Ausprobieren, ob das Deployment funktioniert, habe ich mir eine Resource Group im Azue Portal angelegt und mit dem Befehl:

```
az deployment sub create --template-file solution.bicep --location westeurope --parameters resourceGroupName=<value> name=<value> env=<value> sqlDatabaseName=<value> sqlAdministratorUserName=<value> sqlAdministratorPassword=<value>
```

Ein Deployment durchgeführt. Die Parametersind natürlich frei wählbar, im Rahmen der Anforderungen.

`--location` ist die Region, wo alles erzeugt werden wird

`--parameters` ist die Liste der Parameter, die an das Deploymentscript übergeben werden

`resourceGroupName` der Name der Resource Group, die im Vorfeld in einer Subscription erstellt wurde. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

`name` Name der Applikation und damit auch Kürzel für dieverse Services, die mit der Aplikation interagieren. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

`env` Environment, in der die Applikation deployed wird es ergibt Sinn, wenn es `dev`, `test` und `prod` sind. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

`sqlDatabaseName` Der Name der Datenbank für die App. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

`sqlAdministratorUserName` Der Name des Adiministrators für die Datenbank. Der wird leider benötigt, wenn eine SQL Datenbank per Script erzeugt wird. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

`sqlAdministratorPassword` Das PAsswort des Administrators. Das wird leider benötigt, wenn eine SQL Datenbank per Script erzeugt wird. Der Wert wird im automatischen Deployment durch eine Variablengruppe bereitgestellt.

# Löschen der Resourcen

Um alle Resourcen zu löschen reicht es für dieses Beispiel im Portal die Resource Group zu löschen. Danach ist es aber wichtig, den KeyVault vollständig zu entfernen, denn er ist nur zum Löschen markiert und man kann sonst kein ReDeployment machen.

In der Konsole den Befehl

```
az keyvault purge --name <name des KeyVaults>
```

eingeben und warten (manchmal dauert es ein bisschen).

Mit 

```
az keyvault list-deleted
```

kann überprüft werden, ob der KeyVault wirklich gelöscht wurde.

Das Löschen über die Konsole geht übrigens so:

```
az group delete --name <Name der Resource Group>
```

Aber auch hier nach ist der KeyVault Purge nötig. Ich sags nur :)