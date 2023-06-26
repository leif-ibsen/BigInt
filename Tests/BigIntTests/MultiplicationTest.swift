//
//  MultiplicationTest.swift
//  BigIntTests
//
//  Created by Leif Ibsen on 19/01/2019.
//

import XCTest
@testable import BigInt

class MultiplicationTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func doTest1(_ i: Int) {
        let a = BInt(bitWidth: 200 * i)
        let b = BInt(bitWidth: 100 * i)
        let c = a * b
        let (q, r) = c.quotientAndRemainder(dividingBy: a)
        XCTAssertEqual(r, BInt(0))
        XCTAssertEqual(q, b)
        let (q1, r1) = c.quotientAndRemainder(dividingBy: b)
        XCTAssertEqual(r1, BInt(0))
        XCTAssertEqual(q1, a)
        var am = a.limbs
        am = am.times(am)
        XCTAssertEqual(a * a, BInt(am))
    }

    func test1() {
        for i in 1 ..< 10 {
            doTest1(i)
        }
        doTest1(1000)
    }

    func test2() {
        XCTAssertEqual(BInt.one * BInt.zero, BInt.zero)
        XCTAssertEqual(BInt(-1) * BInt.zero, BInt.zero)
        XCTAssertEqual(BInt.zero * BInt.one, BInt.zero)
        XCTAssertEqual(BInt.zero * BInt(-1), BInt.zero)
        XCTAssertEqual(BInt.one * 0, BInt.zero)
        XCTAssertEqual(BInt(-1) * 0, BInt.zero)
        XCTAssertEqual(0 * BInt.one, BInt.zero)
        XCTAssertEqual(0 * BInt(-1), BInt.zero)
    }

    func test3() {
        XCTAssertEqual(BInt(7) * BInt(4), BInt(28))
        XCTAssertEqual(BInt(7) * BInt(-4), BInt(-28))
        XCTAssertEqual(BInt(-7) * BInt(4), BInt(-28))
        XCTAssertEqual(BInt(-7) * BInt(-4), BInt(28))
        XCTAssertEqual(BInt(-7) * BInt(0), BInt(0))
        XCTAssertEqual(BInt(7) * BInt(0), BInt(0))
        XCTAssertEqual(BInt(7) * 4, BInt(28))
        XCTAssertEqual(BInt(7) * (-4), BInt(-28))
        XCTAssertEqual(BInt(-7) * 4, BInt(-28))
        XCTAssertEqual(BInt(-7) * (-4), BInt(28))
        XCTAssertEqual(BInt(-7) * 0, BInt(0))
        XCTAssertEqual(BInt(7) * 0, BInt(0))
        XCTAssertEqual(7 * BInt(4), BInt(28))
        XCTAssertEqual(7 * BInt(-4), BInt(-28))
        XCTAssertEqual((-7) * BInt(4), BInt(-28))
        XCTAssertEqual((-7) * BInt(-4), BInt(28))
        XCTAssertEqual((-7) * BInt(0), BInt(0))
        XCTAssertEqual(7 * BInt(0), BInt(0))
    }
    
    func test4() {
        let a1000 = BInt(3187705437890850041662973758105262878153514794996698172406519277876060364087986868049465132757493318066301987043192958841748826350731448419937544810921786918975580180410200630645469411588934094075222404396990984350815153163569041641732160380739556436955287671287935796642478260435292021117614349253825)
        let x1000 = BInt(9159373012373110951130589007821321098436345855865428979299172149373720601254669552044211236974571462005332583657082428026625366060511329189733296464187785766230514564038057370938741745651937465362625449921195096442684523511715110908407508139315000469851121118117438147266381183636498494901233452870695)
        let p = BInt (881606031768670370203799623546254635906970563471027096183935255769132818994935105026797736741117884067629414628958490166521677348421497952984090743007386891754592306792733957603908673873956029608745772199466945537867994400553591694676869257752739166500187778285180338575331637398331187710984308778945253310910571200045888397825462631843703774040408386898723732716617035911694875163786438865804688055874155890290534389482646624486981427658975661714755762975406255018921834788692557164591603921160176251176425251485475529879262868939566325382872838605038352127301650325951377189680394903997945614473535796711548836517443228806143410003206606895181583531951291678742814168078542074821043201888888394245898777632836514705209217115520199210073642895025177411502099881559894862875399344537482239219741812012482765733919348104454378485676451995031524570208917785887609710322981279741592576194625901218200627331272625763581518927329962960814810430770117426537088007634480228966554865207873389490385036883324300565832953776054184977163364017697017281028000872219557762132807550086586929734040795789503515226305039566774723973780607434387038174298077204117244573715687699768338812870439809133876998558439112269891900886661828956061577924134616459679678445059151136694799953602037606661158782495248411563029259363939996655530153479758391093606376164653420095454735643618902393689358582625176540723079948543814212531383628215664683435867795314262192413395636645995102740948395010850673188243912983062988430691316183039275264048973763370318264435643316970886088432817691985085984219063671835212438005381682410810517426651688247299665287885514262599515298896962950769895405299340875974176842750168791353483041861634492499841159583974277643635141225110676512130995802577068895339584515423113541072782794859133392065882543336614302550397738095292399935742018008844980636932330723746300879127275060810307460821192156703105758657704640989453518678059061485270563293865646376921941726815605553055049952935969156337298700849739891775846383872293306562639008057275378356654428778635635553201476957497614007400896751187962041031618778670058507255112580964239800918906450469539583786189505218367887826478693788428583330998868059691623015827530278727671138480359369859510472169019238739947081152192261348187777941716142826096149767642808453750484664353587092093220309148806285764680754277119495948804729072818554492218838641142400976435225118645030382237388888566958920454630563661807307611846216241504518523687224723349845563957474610020985599701067824646507629133061661555318375470143998787699713088227100546932379892750118329125591925069900030969495468102613792047313296295055905675954720913783001938962902407670674524874538854823424006788987034165882933513236396580786674022926703477930313793085715653137862289618647687562610200233866397247943349902182622856193712481674493275949914078946608299550560375873997341363968130781483084011461231707522069511876066679049652196284288689159377235124103437044760647404854058598672292958220458072089210818516884896502489909667802977729183689188465424641775627405379871795314627339213079316226211111752667979778400385350252130066546400449083539867490878597053283613068222768132312252866052256790968237402574804609276183500856561635369375010671981508261615265450273829678402611488453703258677720654747639144118281912073374120754430241748922696152188605580632316807953307252489895319388884850069671954804081086230435838321897356692103492450696205095802783366908441061619281502978811661915824206244522115802782566689928201557159554087245460301798015695965383892890137494174610096178108897562332446176315154631066805948677636452047618244452643301170692687738377438444498983401856395738637370500304334167554871056497550319053311325497286471561154462144894202201372269128679493909454986972160801746056745068475434257887613318321759843449482570801550831301969880822256904256479991818414328212808125054098991553547141000844660383035176898612626849908441565836643978091336643662515571580456767863099266342005217955272272235798449548231825496725467416337629917061411826917153134957620169081365352854578849949528255748857481748757787976663581123480328103899241500501962402399317510475482766598768116133369521696184391448993951336789918490078327526525415528574381471924625001829585676499632434560079378802671753535932758211146077808856350063875163863709489042818534410981537833284541579892837501232396658697886457926730760257169120211646844251631108573938636606266599004754964778062631911261546407900938996132422584089821827805161459535525639420932754073060951732428580593626456422729224011263703142595718618781720793144739407727389816026368437371593315828553344736218792871998839564613347935468411245218886168095764820155080610637664935952470373300085167810445535238347944537123416054374971005997372466795732788005782623926049538351093214370187922524090338537700421267394282062576964613986829444400921846315626483205606777984266016655688651869249812889578923732923876101273041469140986543016249314282618597999761461129179747313066560425435520681358172458467203823865007600985034076747902391845280085942121070578567228592750178733242295950009504317859019012647703915600600841588542463912776894184150076764084196788467323628587467031204645739348320720224298399023847386808078723146993172833492245598503187208882427557351030226112128847713383084588998647128264608319426442560987536458987317366283952727617196523521)
        let x1 = a1000 << 8000 + 1
        let x2 = x1000 << 8000 + 1
        XCTAssertEqual(x1 * x2, p)
    }

    func test5() {
        var x1 = BInt(7)
        x1 *= BInt(4)
        XCTAssertEqual(x1, BInt(28))
        var x2 = BInt(7)
        x2 *= BInt(-4)
        XCTAssertEqual(x2, BInt(-28))
        var x3 = BInt(-7)
        x3 *= BInt(4)
        XCTAssertEqual(x3, BInt(-28))
        var x4 = BInt(-7)
        x4 *= BInt(-4)
        XCTAssertEqual(x4, BInt(28))
    }

}
