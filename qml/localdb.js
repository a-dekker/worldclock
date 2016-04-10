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
        tx.executeSql(
                    'CREATE TABLE IF NOT EXISTS country_info(CommonName TEXT PRIMARY KEY UNIQUE, Capital TEXT, ISO4217CurrencyCode TEXT, ISO4217CurrencyName TEXT ,ITU_T_TelephoneCode TEXT ,ISO3166_1_2LetterCode TEXT, ISO3166_1_3LetterCode TEXT, IANACountryCodeTLD TEXT)')
        var rs = tx.executeSql("SELECT * FROM country_info")
        if (rs.rows.length === 0) {
            initCountryInfo()
        }
    })
    return db
}

/*************************************
* Initialize the country_info table
************************************/
function initCountryInfo() {
    var db = connectDB()
    db.transaction(function (tx) {
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Afghanistan","Kabul","AFN","Afghani","93","AF","AFG",".af")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("AlandIslands","Mariehamn","EUR","Euro","340","AX","ALA",".ax")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Albania","Tirana","ALL","Lek","355","AL","ALB",".al")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Algeria","Algiers","DZD","Dinar","213","DZ","DZA",".dz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("AmericanSamoa","Pago Pago","USD","Dollar","-683","AS","ASM",".as")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Andorra","Andorra la Vella","EUR","Euro","376","AD","AND",".ad")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Angola","Luanda","AOA","Kwanza","244","AO","AGO",".ao")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Anguilla","The Valley","XCD","Dollar","-263","AI","AIA",".ai")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("AntiguaAndBarbuda","Saint Johns","XCD","Dollar","-267","AG","ATG",".ag")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Argentina","Buenos Aires","ARS","Peso","54","AR","ARG",".ar")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Armenia","Yerevan","AMD","Dram","374","AM","ARM",".am")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Aruba","Oranjestad","AWG","Guilder","297","AW","ABW",".aw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ascension","Georgetown","SHP","Pound","247","AC","ASC",".ac")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("AshmoreAndCartier Islands","","","","","AU","AUS",".au")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Australia","Canberra","AUD","Dollar","61","AU","AUS",".au")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Austria","Vienna","EUR","Euro","43","AT","AUT",".at")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Azerbaijan","Baku","AZN","Manat","994","AZ","AZE",".az")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bahamas","Nassau","BSD","Dollar","-241","BS","BHS",".bs")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bahrain","Manama","BHD","Dinar","973","BH","BHR",".bh")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bangladesh","Dhaka","BDT","Taka","880","BD","BGD",".bd")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Barbados","Bridgetown","BBD","Dollar","-245","BB","BRB",".bb")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Belarus","Minsk","BYR","Ruble","375","BY","BLR",".by")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Belgium","Brussels","EUR","Euro","32","BE","BEL",".be")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Belize","Belmopan","BZD","Dollar","501","BZ","BLZ",".bz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Benin","Porto-Novo","XOF","Franc","229","BJ","BEN",".bj")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bermuda","Hamilton","BMD","Dollar","-440","BM","BMU",".bm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bhutan","Thimphu","BTN","Ngultrum","975","BT","BTN",".bt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bolivia","La Paz (administrative/legislative) and Sucre (judical)","BOB","Boliviano","591","BO","BOL",".bo")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BosniaAndHerzegowina","Sarajevo","BAM","Marka","387","BA","BIH",".ba")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Botswana","Gaborone","BWP","Pula","267","BW","BWA",".bw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Brazil","Brasilia","BRL","Real","55","BR","BRA",".br")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BritishAntarcticTerritory","","","","","AQ","ATA",".aq")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BritishIndianOceanTerritory","","","","246","IO","IOT",".io")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BritishSovereignBase Areas","Episkopi","CYP","Pound","357","","","")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BritishVirginIslands","Road Town","USD","Dollar","-283","VG","VGB",".vg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Brunei","Bandar Seri Begawan","BND","Dollar","673","BN","BRN",".bn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Bulgaria","Sofia","BGN","Lev","359","BG","BGR",".bg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("BurkinaFaso","Ouagadougou","XOF","Franc","226","BF","BFA",".bf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Burundi","Bujumbura","BIF","Franc","257","BI","BDI",".bi")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Cambodia","Phnom Penh","KHR","Riels","855","KH","KHM",".kh")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Cameroon","Yaounde","XAF","Franc","237","CM","CMR",".cm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Canada","Ottawa","CAD","Dollar","1","CA","CAN",".ca")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CapeVerde","Praia","CVE","Escudo","238","CV","CPV",".cv")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CaymanIslands","George Town","KYD","Dollar","-344","KY","CYM",".ky")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CentralAfricanRepublic","Bangui","XAF","Franc","236","CF","CAF",".cf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Chad","N Djamena","XAF","Franc","235","TD","TCD",".td")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Chile","Santiago (administrative/judical) and Valparaiso (legislative)","CLP","Peso","56","CL","CHL",".cl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("China","Beijing","CNY","Yuan Renminbi","86","CN","CHN",".cn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("ChristmasIsland","The Settlement (Flying Fish Cove)","AUD","Dollar","61","CX","CXR",".cx")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CocosIslands","West Island","AUD","Dollar","61","CC","CCK",".cc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Colombia","Bogota","COP","Peso","57","CO","COL",".co")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Comoros","Moroni","KMF","Franc","269","KM","COM",".km")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CongoBrazzaville","Brazzaville","XAF","Franc","242","CG","COG",".cg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CongoKinshasa","Kinshasa","CDF","Franc","243","CD","COD",".cd")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CookIslands","Avarua","NZD","Dollar","682","CK","COK",".ck")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CoralSeaIslands","","","","","AU","AUS",".au")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CostaRica","San Jose","CRC","Colon","506","CR","CRI",".cr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Croatia","Zagreb","HRK","Kuna","385","HR","HRV",".hr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Cuba","Havana","CUP","Peso","53","CU","CUB",".cu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CuraSao","Willemstad","ANG","Guilder","599","AN","ANT",".an")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Cyprus","Nicosia","CYP","Pound","357","CY","CYP",".cy")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("CzechRepublic","Prague","CZK","Koruna","420","CZ","CZE",".cz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Denmark","Copenhagen","DKK","Krone","45","DK","DNK",".dk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Djibouti","Djibouti","DJF","Franc","253","DJ","DJI",".dj")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Dominica","Roseau","XCD","Dollar","-766","DM","DMA",".dm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("DominicanRepublic","Santo Domingo","DOP","Peso","+1-809 and 1-829","DO","DOM",".do")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("EastTimor","Dili","USD","Dollar","670","TL","TLS",".tp and .tl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ecuador","Quito","USD","Dollar","593","EC","ECU",".ec")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Egypt","Cairo","EGP","Pound","20","EG","EGY",".eg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("ElSalvador","San Salvador","USD","Dollar","503","SV","SLV",".sv")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("EquatorialGuinea","Malabo","XAF","Franc","240","GQ","GNQ",".gq")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Eritrea","Asmara","ERN","Nakfa","291","ER","ERI",".er")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Estonia","Tallinn","EEK","Kroon","372","EE","EST",".ee")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ethiopia","Addis Ababa","ETB","Birr","251","ET","ETH",".et")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("FalklandIslands (Islas Malvinas)","Stanley","FKP","Pound","500","FK","FLK",".fk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("FaroeIslands","Torshavn","DKK","Krone","298","FO","FRO",".fo")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Fiji","Suva","FJD","Dollar","679","FJ","FJI",".fj")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Finland","Helsinki","EUR","Euro","358","FI","FIN",".fi")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("France","Paris","EUR","Euro","33","FR","FRA",".fr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("FrenchGuiana","Cayenne","EUR","Euro","594","GF","GUF",".gf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("FrenchPolynesia","Papeete","XPF","Franc","689","PF","PYF",".pf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("FrenchSouthernTerritories","Martin-de-Viviès","","","","TF","ATF",".tf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Gabon","Libreville","XAF","Franc","241","GA","GAB",".ga")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Gambia","Banjul","GMD","Dalasi","220","GM","GMB",".gm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Georgia","Tbilisi","GEL","Lari","995","GE","GEO",".ge")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Germany","Berlin","EUR","Euro","49","DE","DEU",".de")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ghana","Accra","GHC","Cedi","233","GH","GHA",".gh")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Gibraltar","Gibraltar","GIP","Pound","350","GI","GIB",".gi")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Greece","Athens","EUR","Euro","30","GR","GRC",".gr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Greenland","Nuuk (Godthab)","DKK","Krone","299","GL","GRL",".gl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Grenada","Saint Georges","XCD","Dollar","-472","GD","GRD",".gd")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guadeloupe","Basse-Terre","EUR","Euro","590","GP","GLP",".gp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guam","Hagatna","USD","Dollar","-670","GU","GUM",".gu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guatemala","Guatemala","GTQ","Quetzal","502","GT","GTM",".gt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guernsey","Saint Peter Port","GGP","Pound","44","GG","GGY",".gg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guinea","Conakry","GNF","Franc","224","GN","GIN",".gn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("GuineaBissau","Bissau","XOF","Franc","245","GW","GNB",".gw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Guyana","Georgetown","GYD","Dollar","592","GY","GUY",".gy")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Haiti","Port-au-Prince","HTG","Gourde","509","HT","HTI",".ht")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("HeardIslandAndMcDonald Islands","","","","","HM","HMD",".hm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Honduras","Tegucigalpa","HNL","Lempira","504","HN","HND",".hn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("HongKong","","HKD","Dollar","852","HK","HKG",".hk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Hungary","Budapest","HUF","Forint","36","HU","HUN",".hu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Iceland","Reykjavik","ISK","Krona","354","IS","ISL",".is")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("India","New Delhi","INR","Rupee","91","IN","IND",".in")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Indonesia","Jakarta","IDR","Rupiah","62","ID","IDN",".id")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Iran","Tehran","IRR","Rial","98","IR","IRN",".ir")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Iraq","Baghdad","IQD","Dinar","964","IQ","IRQ",".iq")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ireland","Dublin","EUR","Euro","353","IE","IRL",".ie")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("IsleOfMan","Douglas","IMP","Pound","44","IM","IMN",".im")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Israel","Jerusalem","ILS","Shekel","972","IL","ISR",".il")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Italy","Rome","EUR","Euro","39","IT","ITA",".it")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("IvoryCoast","Yamoussoukro","XOF","Franc","225","CI","CIV",".ci")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Jamaica","Kingston","JMD","Dollar","-875","JM","JAM",".jm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Japan","Tokyo","JPY","Yen","81","JP","JPN",".jp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Jersey","Saint Helier","JEP","Pound","44","JE","JEY",".je")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Jordan","Amman","JOD","Dinar","962","JO","JOR",".jo")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Kazakhstan","Astana","KZT","Tenge","7","KZ","KAZ",".kz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Kenya","Nairobi","KES","Shilling","254","KE","KEN",".ke")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Kiribati","Tarawa","AUD","Dollar","686","KI","KIR",".ki")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Kuwait","Kuwait","KWD","Dinar","965","KW","KWT",".kw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Kyrgyzstan","Bishkek","KGS","Som","996","KG","KGZ",".kg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Laos","Vientiane","LAK","Kip","856","LA","LAO",".la")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Latvia","Riga","LVL","Lat","371","LV","LVA",".lv")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Lebanon","Beirut","LBP","Pound","961","LB","LBN",".lb")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Lesotho","Maseru","LSL","Loti","266","LS","LSO",".ls")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Liberia","Monrovia","LRD","Dollar","231","LR","LBR",".lr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Libya","Tripoli","LYD","Dinar","218","LY","LBY",".ly")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Liechtenstein","Vaduz","CHF","Franc","423","LI","LIE",".li")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Lithuania","Vilnius","LTL","Litas","370","LT","LTU",".lt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Luxembourg","Luxembourg","EUR","Euro","352","LU","LUX",".lu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Macau","Macau","MOP","Pataca","853","MO","MAC",".mo")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Macedonia","Skopje","MKD","Denar","389","MK","MKD",".mk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Madagascar","Antananarivo","MGA","Ariary","261","MG","MDG",".mg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Malawi","Lilongwe","MWK","Kwacha","265","MW","MWI",".mw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Malaysia","Kuala Lumpur (legislative/judical) and Putrajaya (administrative)","MYR","Ringgit","60","MY","MYS",".my")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Maldives","Male","MVR","Rufiyaa","960","MV","MDV",".mv")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mali","Bamako","XOF","Franc","223","ML","MLI",".ml")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Malta","Valletta","MTL","Lira","356","MT","MLT",".mt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("MarshallIslands","Majuro","USD","Dollar","692","MH","MHL",".mh")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Martinique","Fort-de-France","EUR","Euro","596","MQ","MTQ",".mq")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mauritania","Nouakchott","MRO","Ouguiya","222","MR","MRT",".mr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mauritius","Port Louis","MUR","Rupee","230","MU","MUS",".mu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mayotte","Mamoudzou","EUR","Euro","262","YT","MYT",".yt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mexico","Mexico","MXN","Peso","52","MX","MEX",".mx")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Micronesia","Palikir","USD","Dollar","691","FM","FSM",".fm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("MidwayIslands","","","","","UM","UMI","")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Moldova","Chisinau","MDL","Leu","373","MD","MDA",".md")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Monaco","Monaco","EUR","Euro","377","MC","MCO",".mc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mongolia","Ulaanbaatar","MNT","Tugrik","976","MN","MNG",".mn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Montenegro","Podgorica","EUR","Euro","382","ME","MNE",".me and .yu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Montserrat","Plymouth","XCD","Dollar","-663","MS","MSR",".ms")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Morocco","Rabat","MAD","Dirham","212","MA","MAR",".ma")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Mozambique","Maputo","MZM","Meticail","258","MZ","MOZ",".mz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Myanmar","Naypyidaw","MMK","Kyat","95","MM","MMR",".mm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NagornoKarabakh","Stepanakert","AMD","Dram","277","AZ","AZE",".az")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Namibia","Windhoek","NAD","Dollar","264","NA","NAM",".na")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Nauru","Yaren","AUD","Dollar","674","NR","NRU",".nr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Nepal","Kathmandu","NPR","Rupee","977","NP","NPL",".np")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Netherlands","Amsterdam (administrative) and The Hague (legislative/judical)","EUR","Euro","31","NL","NLD",".nl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NewCaledonia","Noumea","XPF","Franc","687","NC","NCL",".nc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NewZealand","Wellington","NZD","Dollar","64","NZ","NZL",".nz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Nicaragua","Managua","NIO","Cordoba","505","NI","NIC",".ni")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Niger","Niamey","XOF","Franc","227","NE","NER",".ne")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Nigeria","Abuja","NGN","Naira","234","NG","NGA",".ng")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Niue","Alofi","NZD","Dollar","683","NU","NIU",".nu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NorfolkIsland","Kingston","AUD","Dollar","672","NF","NFK",".nf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NorthKorea","Pyongyang","KPW","Won","850","KP","PRK",".kp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("NorthernMarianaIslands","Saipan","USD","Dollar","-669","MP","MNP",".mp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Norway","Oslo","NOK","Krone","47","NO","NOR",".no")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Oman","Muscat","OMR","Rial","968","OM","OMN",".om")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Pakistan","Islamabad","PKR","Rupee","92","PK","PAK",".pk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Palau","Melekeok","USD","Dollar","680","PW","PLW",".pw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Panama","Panama","PAB","Balboa","507","PA","PAN",".pa")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("PapuaNewGuinea","Port Moresby","PGK","Kina","675","PG","PNG",".pg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Paraguay","Asuncion","PYG","Guarani","595","PY","PRY",".py")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Peru","Lima","PEN","Sol","51","PE","PER",".pe")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Philippines","Manila","PHP","Peso","63","PH","PHL",".ph")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Pitcairn Islands","Adamstown","NZD","Dollar","","PN","PCN",".pn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Poland","Warsaw","PLN","Zloty","48","PL","POL",".pl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Portugal","Lisbon","EUR","Euro","351","PT","PRT",".pt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Pridnestrovie (Transnistria)","Tiraspol","","Ruple","-160","MD","MDA",".md")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("PuertoRico","San Juan","USD","Dollar","+1-787 and 1-939","PR","PRI",".pr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Qatar","Doha","QAR","Rial","974","QA","QAT",".qa")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("QueenMaudLand","","","","","AQ","ATA",".aq")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Reunion","Saint-Denis","EUR","Euro","262","RE","REU",".re")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Romania","Bucharest","RON","Leu","40","RO","ROU",".ro")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Russia","Moscow","RUB","Ruble","7","RU","RUS",".ru and .su")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Rwanda","Kigali","RWF","Franc","250","RW","RWA",".rw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Saint Barthelemy","Gustavia","EUR","Euro","590","GP","GLP",".gp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaintHelena","Jamestown","SHP","Pound","290","SH","SHN",".sh")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaintKittsAndNevis","Basseterre","XCD","Dollar","-868","KN","KNA",".kn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaintLucia","Castries","XCD","Dollar","-757","LC","LCA",".lc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaintPierreAndMiquelon","Saint-Pierre","EUR","Euro","508","PM","SPM",".pm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaintVincentAndTheGrenadines","Kingstown","XCD","Dollar","-783","VC","VCT",".vc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Samoa","Apia","WST","Tala","685","WS","WSM",".ws")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SanMarino","San Marino","EUR","Euro","378","SM","SMR",".sm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaoTomeAndPrincipe","Sao Tome","STD","Dobra","239","ST","STP",".st")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SaudiArabia","Riyadh","SAR","Rial","966","SA","SAU",".sa")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Senegal","Dakar","XOF","Franc","221","SN","SEN",".sn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Serbia","Belgrade","RSD","Dinar","381","RS","SRB",".rs and .yu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Seychelles","Victoria","SCR","Rupee","248","SC","SYC",".sc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SierraLeone","Freetown","SLL","Leone","232","SL","SLE",".sl")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Singapore","Singapore","SGD","Dollar","65","SG","SGP",".sg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SintMaarten","Marigot","EUR","Euro","590","GP","GLP",".gp")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Slovakia","Bratislava","SKK","Koruna","421","SK","SVK",".sk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Slovenia","Ljubljana","EUR","Euro","386","SI","SVN",".si")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SolomonIslands","Honiara","SBD","Dollar","677","SB","SLB",".sb")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Somalia","Mogadishu","SOS","Shilling","252","SO","SOM",".so")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Somaliland","Hargeisa","","Shilling","252","SO","SOM",".so")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SouthAfrica","Pretoria (administrative) Cape Town (legislative) and Bloemfontein (judical)","ZAR","Rand","27","ZA","ZAF",".za")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SouthGeorgiaAndTheSouthSandwichIslands","","","","","GS","SGS",".gs")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SouthKorea","Seoul","KRW","Won","82","KR","KOR",".kr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SouthOssetia","Tskhinvali","RUB and GEL","Ruble and Lari","995","GE","GEO",".ge")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Spain","Madrid","EUR","Euro","34","ES","ESP",".es")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SriLanka","Colombo (administrative/judical) and Sri Jayewardenepura Kotte (legislative)","LKR","Rupee","94","LK","LKA",".lk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Sudan","Khartoum","SDD","Dinar","249","SD","SDN",".sd")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Suriname","Paramaribo","SRD","Dollar","597","SR","SUR",".sr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("SvalbardAndJanMayenIslands","Longyearbyen","NOK","Krone","47","SJ","SJM",".sj")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Swaziland","Mbabane (administrative) and Lobamba (legislative)","SZL","Lilangeni","268","SZ","SWZ",".sz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Sweden","Stockholm","SEK","Kronoa","46","SE","SWE",".se")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Switzerland","Bern","CHF","Franc","41","CH","CHE",".ch")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Syria","Damascus","SYP","Pound","963","SY","SYR",".sy")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Taiwan","Taipei","TWD","Dollar","886","TW","TWN",".tw")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tajikistan","Dushanbe","TJS","Somoni","992","TJ","TJK",".tj")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tanzania","Dar es Salaam (administrative/judical) and Dodoma (legislative)","TZS","Shilling","255","TZ","TZA",".tz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Thailand","Bangkok","THB","Baht","66","TH","THA",".th")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Togo","Lome","XOF","Franc","228","TG","TGO",".tg")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tokelau","","NZD","Dollar","690","TK","TKL",".tk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tonga","Nuku alofa","TOP","Pa anga","676","TO","TON",".to")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("TrinidadAndTobago","Port-of-Spain","TTD","Dollar","-867","TT","TTO",".tt")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tunisia","Tunis","TND","Dinar","216","TN","TUN",".tn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Turkey","Ankara","TRY","Lira","90","TR","TUR",".tr")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Turkmenistan","Ashgabat","TMM","Manat","993","TM","TKM",".tm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("TurksAndCaicosIslands","Grand Turk","USD","Dollar","-648","TC","TCA",".tc")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Tuvalu","Funafuti","AUD","Dollar","688","TV","TUV",".tv")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Uganda","Kampala","UGX","Shilling","256","UG","UGA",".ug")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Ukraine","Kiev","UAH","Hryvnia","380","UA","UKR",".ua")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("UnitedArabEmirates","Abu Dhabi","AED","Dirham","971","AE","ARE",".ae")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("UnitedKingdom","London","GBP","Pound","44","GB","GBR",".uk")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("UnitedStates","Washington","USD","Dollar","1","US","USA",".us")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("UnitedStatesVirginIslands","Charlotte Amalie","USD","Dollar","-339","VI","VIR",".vi")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Uruguay","Montevideo","UYU","Peso","598","UY","URY",".uy")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Uzbekistan","Tashkent","UZS","Som","998","UZ","UZB",".uz")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Vanuatu","Port-Vila","VUV","Vatu","678","VU","VUT",".vu")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("VaticanCityState","Vatican City","EUR","Euro","379","VA","VAT",".va")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Venezuela","Caracas","VEB","Bolivar","58","VE","VEN",".ve")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Vietnam","Hanoi","VND","Dong","84","VN","VNM",".vn")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("WakeIsland","","","","","UM","UMI","")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("WallisAndFutunaIslands","Mata utu","XPF","Franc","681","WF","WLF",".wf")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Yemen","Sanaa","YER","Rial","967","YE","YEM",".ye")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Zambia","Lusaka","ZMK","Kwacha","260","ZM","ZMB",".zm")')
        tx.executeSql(
                    'insert into country_info (CommonName,Capital,ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD) values ("Zimbabwe","Harare","ZWD","Dollar","263","ZW","ZWE",".zw")')
    })
}

/*********************
 * read country info
  ********************/
function getCountryInfo(country) {
    var db = connectDB()
    var retVal = ""
    db.transaction(function (tx) {
        var rs = tx.executeSql(
                    'SELECT ISO4217CurrencyCode,ISO4217CurrencyName,ITU_T_TelephoneCode,ISO3166_1_2LetterCode,ISO3166_1_3LetterCode,IANACountryCodeTLD FROM country_info WHERE CommonName=?',
                    [country])
        if (rs.rows.length > 0) {
            retVal = rs.rows.item(0).ISO4217CurrencyCode + '|' + rs.rows.item(
                        0).ISO4217CurrencyName + '|' + rs.rows.item(
                        0).ITU_T_TelephoneCode + '|' + rs.rows.item(
                        0).ISO3166_1_2LetterCode + '|' + rs.rows.item(
                        0).ISO3166_1_3LetterCode + '|' + rs.rows.item(
                        0).IANACountryCodeTLD
        } else {
            retVal = qsTr("Unknown")
        }
    })
    return retVal
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
            aliasesDialog.appendCustomCity(result.rows.item(i).City, "",
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
