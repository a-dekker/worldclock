.import QtQuick.LocalStorage 2.0 as LS

function connectDB() {
    // connect to the local database
    return LS.LocalStorage.openDatabaseSync("harbour-worldclock", "1.0",
                                            "harbour-worldclock Database",
                                            100000)
}

function initializeDB() {
    // initialize DB connection
    var db = connectDB()

    // run initialization queries
    db.transaction(function (tx) {
        // create table
        tx.executeSql(
                    "CREATE TABLE IF NOT EXISTS city_aliases(CityInfo TEXT, City TEXT, Alias TEXT UNIQUE, Displayed boolean NOT NULL default 0)")
        tx.executeSql(
                    "CREATE UNIQUE INDEX IF NOT EXISTS uid ON city_aliases(Alias)")
    })
    return db
}

/****************************************/
/*** SQL functions for ALIAS handling ***/
/****************************************/

// select aliases and push them into the aliaslist
function readAliases() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql(
                    "SELECT * FROM city_aliases ORDER BY City COLLATE NOCASE;")
        for (var i = 0; i < result.rows.length; i++) {
            aliasesDialog.appendCustomCity(result.rows.item(i).City,
                                           result.rows.item(i).CityInfo,
                                           result.rows.item(i).Alias,
                                           result.rows.item(i).Displayed)
        }
    })
}

// select aliases and push them into the aliaslist
function readActiveAliases() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql(
                    "SELECT * FROM city_aliases where Displayed = 'true' ORDER BY City COLLATE NOCASE;")
        mainapp.myAliases = ""
        for (var i = 0; i < result.rows.length; i++) {
            mainapp.myAliases += result.rows.item(
                        i).CityInfo + "|" + result.rows.item(i).Alias + "\n"
        }
    })
}

function removeAllAliases() {
    var db = connectDB()

    db.transaction(function (tx) {
        var result = tx.executeSql("delete FROM city_aliases;")
        tx.executeSql("COMMIT;")
    })
}

// save custom city
function writeAlias(cityinfo, city, alias, displayed) {
    var db = connectDB()
    var result

    try {
        db.transaction(function (tx) {
            tx.executeSql(
                        "INSERT INTO city_aliases (CityInfo, City, Alias,Displayed) VALUES (?, ?, ?, ?);",
                        [cityinfo, city, alias, displayed])
            tx.executeSql("COMMIT;")
            result = tx.executeSql(
                        "SELECT City FROM city_aliases WHERE City=?;", [city])
        })

        return result.rows.item(0).City
    } catch (sqlErr) {
        return "ERROR"
    }
}
