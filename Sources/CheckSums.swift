//
//  CheckSums.swift
//  SWCompression
//
//  Created by Timofey Solomko on 18.12.16.
//  Copyright © 2017 Timofey Solomko. All rights reserved.
//

import Foundation

struct CheckSums {

    // MARK: Functions

    static func crc32(_ array: [UInt8], prevValue: UInt32 = 0) -> UInt32 {
        var crc = ~prevValue
        for i in 0..<array.count {
            let index = (crc & 0xFF) ^ (UInt32(array[i]))
            crc = CheckSums.crc32table[Int(index)] ^ (crc >> 8)
        }
        return ~crc
    }

    static func crc32(_ data: Data) -> UInt32 {
        var crc: UInt32 = ~0
        for i in 0..<data.count {
            let index = (crc & 0xFF) ^ (UInt32(data[i]))
            crc = CheckSums.crc32table[Int(index)] ^ (crc >> 8)
        }
        return ~crc
    }

    static func bzip2CRC32(_ array: [UInt8]) -> UInt32 {
        var crc: UInt32 = 0xFFFFFFFF
        for i in 0..<array.count {
            let index = UInt32(array[i])
            crc = (crc << 8) ^ CheckSums.bzip2CRC32table[Int((crc >> 24) ^ index)]
        }
        return ~crc
    }

    static func crc64(_ array: [UInt8]) -> UInt64 {
        var crc: UInt64 = ~0
        for i in 0..<array.count {
            let index = (crc & 0xFF) ^ (UInt64(array[i]))
            crc = CheckSums.crc64table[Int(bitPattern: UInt(truncatingBitPattern: index))] ^ (crc >> 8)
        }
        return ~crc
    }

    static func adler32(_ array: [UInt8]) -> Int {
        let base = 65521
        var s1 = 1
        var s2 = 0
        for i in 0..<array.count {
            s1 = (s1 + array[i].toInt()) % base
            s2 = (s2 + s1) % base
        }
        return (s2 << 16) + s1
    }

    static func adler32(_ data: Data) -> Int {
        let base = 65521
        var s1 = 1
        var s2 = 0
        for i in 0..<data.count {
            s1 = (s1 + data[i].toInt()) % base
            s2 = (s2 + s1) % base
        }
        return (s2 << 16) + s1
    }

    // MARK: Tables

    private static let crc32table: [UInt32] =
        [0, 1996959894, 3993919788, 2567524794, 124634137, 1886057615, 3915621685, 2657392035, 249268274,
         2044508324, 3772115230, 2547177864, 162941995, 2125561021, 3887607047, 2428444049, 498536548,
         1789927666, 4089016648, 2227061214, 450548861, 1843258603, 4107580753, 2211677639, 325883990,
         1684777152, 4251122042, 2321926636, 335633487, 1661365465, 4195302755, 2366115317, 997073096,
         1281953886, 3579855332, 2724688242, 1006888145, 1258607687, 3524101629, 2768942443, 901097722,
         1119000684, 3686517206, 2898065728, 853044451, 1172266101, 3705015759, 2882616665, 651767980,
         1373503546, 3369554304, 3218104598, 565507253, 1454621731, 3485111705, 3099436303, 671266974,
         1594198024, 3322730930, 2970347812, 795835527, 1483230225, 3244367275, 3060149565, 1994146192,
         31158534, 2563907772, 4023717930, 1907459465, 112637215, 2680153253, 3904427059, 2013776290,
         251722036, 2517215374, 3775830040, 2137656763, 141376813, 2439277719, 3865271297, 1802195444,
         476864866, 2238001368, 4066508878, 1812370925, 453092731, 2181625025, 4111451223, 1706088902,
         314042704, 2344532202, 4240017532, 1658658271, 366619977, 2362670323, 4224994405, 1303535960,
         984961486, 2747007092, 3569037538, 1256170817, 1037604311, 2765210733, 3554079995, 1131014506,
         879679996, 2909243462, 3663771856, 1141124467, 855842277, 2852801631, 3708648649, 1342533948,
         654459306, 3188396048, 3373015174, 1466479909, 544179635, 3110523913, 3462522015, 1591671054,
         702138776, 2966460450, 3352799412, 1504918807, 783551873, 3082640443, 3233442989, 3988292384,
         2596254646, 62317068, 1957810842, 3939845945, 2647816111, 81470997, 1943803523, 3814918930,
         2489596804, 225274430, 2053790376, 3826175755, 2466906013, 167816743, 2097651377, 4027552580,
         2265490386, 503444072, 1762050814, 4150417245, 2154129355, 426522225, 1852507879, 4275313526,
         2312317920, 282753626, 1742555852, 4189708143, 2394877945, 397917763, 1622183637, 3604390888,
         2714866558, 953729732, 1340076626, 3518719985, 2797360999, 1068828381, 1219638859, 3624741850,
         2936675148, 906185462, 1090812512, 3747672003, 2825379669, 829329135, 1181335161, 3412177804,
         3160834842, 628085408, 1382605366, 3423369109, 3138078467, 570562233, 1426400815, 3317316542,
         2998733608, 733239954, 1555261956, 3268935591, 3050360625, 752459403, 1541320221, 2607071920,
         3965973030, 1969922972, 40735498, 2617837225, 3943577151, 1913087877, 83908371, 2512341634,
         3803740692, 2075208622, 213261112, 2463272603, 3855990285, 2094854071, 198958881, 2262029012,
         4057260610, 1759359992, 534414190, 2176718541, 4139329115, 1873836001, 414664567, 2282248934,
         4279200368, 1711684554, 285281116, 2405801727, 4167216745, 1634467795, 376229701, 2685067896,
         3608007406, 1308918612, 956543938, 2808555105, 3495958263, 1231636301, 1047427035, 2932959818,
         3654703836, 1088359270, 936918000, 2847714899, 3736837829, 1202900863, 817233897, 3183342108,
         3401237130, 1404277552, 615818150, 3134207493, 3453421203, 1423857449, 601450431, 3009837614,
         3294710456, 1567103746, 711928724, 3020668471, 3272380065, 1510334235, 755167117]

    private static let bzip2CRC32table: [UInt32] =
        [0x00000000, 0x04c11db7, 0x09823b6e, 0x0d4326d9, 0x130476dc, 0x17c56b6b, 0x1a864db2, 0x1e475005,
         0x2608edb8, 0x22c9f00f, 0x2f8ad6d6, 0x2b4bcb61, 0x350c9b64, 0x31cd86d3, 0x3c8ea00a, 0x384fbdbd,
         0x4c11db70, 0x48d0c6c7, 0x4593e01e, 0x4152fda9, 0x5f15adac, 0x5bd4b01b, 0x569796c2, 0x52568b75,
         0x6a1936c8, 0x6ed82b7f, 0x639b0da6, 0x675a1011, 0x791d4014, 0x7ddc5da3, 0x709f7b7a, 0x745e66cd,
         0x9823b6e0, 0x9ce2ab57, 0x91a18d8e, 0x95609039, 0x8b27c03c, 0x8fe6dd8b, 0x82a5fb52, 0x8664e6e5,
         0xbe2b5b58, 0xbaea46ef, 0xb7a96036, 0xb3687d81, 0xad2f2d84, 0xa9ee3033, 0xa4ad16ea, 0xa06c0b5d,
         0xd4326d90, 0xd0f37027, 0xddb056fe, 0xd9714b49, 0xc7361b4c, 0xc3f706fb, 0xceb42022, 0xca753d95,
         0xf23a8028, 0xf6fb9d9f, 0xfbb8bb46, 0xff79a6f1, 0xe13ef6f4, 0xe5ffeb43, 0xe8bccd9a, 0xec7dd02d,
         0x34867077, 0x30476dc0, 0x3d044b19, 0x39c556ae, 0x278206ab, 0x23431b1c, 0x2e003dc5, 0x2ac12072,
         0x128e9dcf, 0x164f8078, 0x1b0ca6a1, 0x1fcdbb16, 0x018aeb13, 0x054bf6a4, 0x0808d07d, 0x0cc9cdca,
         0x7897ab07, 0x7c56b6b0, 0x71159069, 0x75d48dde, 0x6b93dddb, 0x6f52c06c, 0x6211e6b5, 0x66d0fb02,
         0x5e9f46bf, 0x5a5e5b08, 0x571d7dd1, 0x53dc6066, 0x4d9b3063, 0x495a2dd4, 0x44190b0d, 0x40d816ba,
         0xaca5c697, 0xa864db20, 0xa527fdf9, 0xa1e6e04e, 0xbfa1b04b, 0xbb60adfc, 0xb6238b25, 0xb2e29692,
         0x8aad2b2f, 0x8e6c3698, 0x832f1041, 0x87ee0df6, 0x99a95df3, 0x9d684044, 0x902b669d, 0x94ea7b2a,
         0xe0b41de7, 0xe4750050, 0xe9362689, 0xedf73b3e, 0xf3b06b3b, 0xf771768c, 0xfa325055, 0xfef34de2,
         0xc6bcf05f, 0xc27dede8, 0xcf3ecb31, 0xcbffd686, 0xd5b88683, 0xd1799b34, 0xdc3abded, 0xd8fba05a,
         0x690ce0ee, 0x6dcdfd59, 0x608edb80, 0x644fc637, 0x7a089632, 0x7ec98b85, 0x738aad5c, 0x774bb0eb,
         0x4f040d56, 0x4bc510e1, 0x46863638, 0x42472b8f, 0x5c007b8a, 0x58c1663d, 0x558240e4, 0x51435d53,
         0x251d3b9e, 0x21dc2629, 0x2c9f00f0, 0x285e1d47, 0x36194d42, 0x32d850f5, 0x3f9b762c, 0x3b5a6b9b,
         0x0315d626, 0x07d4cb91, 0x0a97ed48, 0x0e56f0ff, 0x1011a0fa, 0x14d0bd4d, 0x19939b94, 0x1d528623,
         0xf12f560e, 0xf5ee4bb9, 0xf8ad6d60, 0xfc6c70d7, 0xe22b20d2, 0xe6ea3d65, 0xeba91bbc, 0xef68060b,
         0xd727bbb6, 0xd3e6a601, 0xdea580d8, 0xda649d6f, 0xc423cd6a, 0xc0e2d0dd, 0xcda1f604, 0xc960ebb3,
         0xbd3e8d7e, 0xb9ff90c9, 0xb4bcb610, 0xb07daba7, 0xae3afba2, 0xaafbe615, 0xa7b8c0cc, 0xa379dd7b,
         0x9b3660c6, 0x9ff77d71, 0x92b45ba8, 0x9675461f, 0x8832161a, 0x8cf30bad, 0x81b02d74, 0x857130c3,
         0x5d8a9099, 0x594b8d2e, 0x5408abf7, 0x50c9b640, 0x4e8ee645, 0x4a4ffbf2, 0x470cdd2b, 0x43cdc09c,
         0x7b827d21, 0x7f436096, 0x7200464f, 0x76c15bf8, 0x68860bfd, 0x6c47164a, 0x61043093, 0x65c52d24,
         0x119b4be9, 0x155a565e, 0x18197087, 0x1cd86d30, 0x029f3d35, 0x065e2082, 0x0b1d065b, 0x0fdc1bec,
         0x3793a651, 0x3352bbe6, 0x3e119d3f, 0x3ad08088, 0x2497d08d, 0x2056cd3a, 0x2d15ebe3, 0x29d4f654,
         0xc5a92679, 0xc1683bce, 0xcc2b1d17, 0xc8ea00a0, 0xd6ad50a5, 0xd26c4d12, 0xdf2f6bcb, 0xdbee767c,
         0xe3a1cbc1, 0xe760d676, 0xea23f0af, 0xeee2ed18, 0xf0a5bd1d, 0xf464a0aa, 0xf9278673, 0xfde69bc4,
         0x89b8fd09, 0x8d79e0be, 0x803ac667, 0x84fbdbd0, 0x9abc8bd5, 0x9e7d9662, 0x933eb0bb, 0x97ffad0c,
         0xafb010b1, 0xab710d06, 0xa6322bdf, 0xa2f33668, 0xbcb4666d, 0xb8757bda, 0xb5365d03, 0xb1f740b4]

    private static let crc64table: [UInt64] =
        [0, 12911341560706588527, 17619267392293085275, 5164075066763771700, 8921845837811637811,
         14483170935171449180, 10328150133527543400, 4357999468653093127, 17843691675623275622,
         4940391307328217865, 226782375002905661, 12685511915359257426, 10119945210068853333,
         4566377562367245626, 8715998937306186254, 14689403211693301089, 9051005139383707209,
         14895072503764629798, 9880782614656435730, 4193374422961527165, 453564750005811322,
         13070904082541799189, 17496296445768931361, 4747102235666401102, 9960315520700766767,
         4113029525020509504, 9132755124734491252, 14812441257301386523, 17431997874612372508,
         4811156168024382323, 391483189436228679, 13132671735097031464, 18102010278767414418,
         5195199925788447741, 1131375642422963401, 13591081480414639014, 9288535643022529185,
         3731739485546663374, 8386748845923054330, 14361410892855143829, 907129500011622644,
         13814943346342178715, 17875617253995106479, 5421418680781082560, 8594564625313771207,
         14152643483341451688, 9494204471332802204, 3525329033817543155, 9704381199536204507,
         3855837706121835956, 8226059050041019008, 13908973417437222383, 18265510249468982504,
         5643692520190618503, 718348998302913715, 13463047253836762076, 8146277531524994749,
         13989069943491807698, 9622312336048764646, 3938150108875254153, 782966378872457358,
         13399312233903888353, 18327840216347633877, 5582173445676054458, 7257036000092981153,
         15535280666427316430, 10390399851576895482, 2529986302517213333, 2262751284845926802,
         12414353723947190013, 16997392145760156105, 6398650419759490726, 10599130201908394951,
         2322133910755632296, 7463478971093326748, 15329644185724306675, 16773497691846108660,
         6622864283287239323, 2036569382881248687, 12640783567252986560, 1814259000023245288,
         12250853444207230599, 17125426475222188467, 6811676960462675676, 7132938157145702363,
         15119434731753103540, 10842837361562165120, 2690676064372932847, 17189129250627542414,
         6747026957542163169, 1875814858707893717, 12188560364711551674, 10762704257491731389,
         2770420489343360210, 7050658067635086310, 15201536148867841161, 11493583972846619443,
         3219832958944941148, 7711675412243671912, 15576564987190227975, 16452118100082038016,
         6305011443818121839, 1213047649942025563, 11816267669673208372, 7503259434831574869,
         15784731923736995898, 11287385040381237006, 3425713581329221729, 1436697996605827430,
         11591809733187859977, 16677985422973077821, 6078267261889762898, 16292555063049989498,
         5851447209550246421, 1630020308903038241, 11939238787801010766, 11081681957373440841,
         3090674103720225830, 7876300217750508306, 16023932746787097725, 1565932757744914716,
         12003503911822413427, 16230825569204842823, 5913566482019610152, 7956607163135676207,
         15944361922680361024, 11164346891352108916, 3008957496780927003, 14514072000185962306,
         8809633696146542637, 4460922918905818905, 10287960411460399222, 12879331835779764593,
         113391187501452830, 5059972605034426666, 17660565739912801861, 4525502569691853604,
         10224187249629523019, 14576435430675780479, 8748148222884465680, 4980157760350383383,
         17740628527280140920, 12797300839518981452, 195741594718114339, 13040162471224305931,
         565687821211481700, 4644267821511264592, 17536326748496696895, 14926957942186653496,
         8937808626997553239, 4297282312656885603, 9839608450464401420, 4852190599768102253,
         17327666750234135042, 13245728566574478646, 359174499151456857, 4073138765762497374,
         10063573324157604913, 14700457781105076997, 9163920108173816938, 3628518000046490576,
         9328460452529085631, 14330211790445699979, 8498696072880078052, 5299565100954197475,
         18061012165519327884, 13623353920925351352, 1018284691440624343, 14265876314291404726,
         8562713237611094233, 3566469078572851181, 9390260331795218562, 13702854325316886917,
         937907429353946858, 5381352128745865694, 17978417549248290481, 5746791986423309721,
         18225777846762470134, 13494053915084326338, 606523824971012781, 3751629717415787434,
         9745292510640121029, 13876787882151992305, 8338992711486538910, 13285957365033343487,
         815010154451519120, 5540840978686720420, 18431906428167644875, 14101316135270172620,
         8115412784602421411, 3978303581567838103, 9519354766961195256, 12527462061959317731,
         2230461459452909452, 6439665917889882296, 16893009583564617687, 15423350824487343824,
         7288217715337890239, 2490078880175191691, 10493603952060017124, 6520081235612152965,
         16813546994155744234, 12610022887636243678, 2148641156328442801, 2426095299884051126,
         10557972909709735385, 15361512820870335213, 7350228890552538498, 15006518869663149738,
         7165105895222849989, 2649782550477098737, 10947027550912647582, 12362696414880903321,
         1783234539286425590, 6851427162658443458, 17022309211647725485, 2873395993211654860,
         10722532847870938531, 15232418832718623383, 6938393941075996152, 6642978682516671743,
         17230443782969840528, 12156534523779525796, 1989151790783919051, 6263731030979658865,
         16556202624882645790, 11702894419100492842, 1245039440087595845, 3260040617806076482,
         11390642587947386157, 15688795063501830681, 7680756410435167606, 11622868312827688983,
         1324891275238549368, 6181348207440451660, 16638201170595874595, 15752600435501016612,
         7616209416359311691, 3321489341258335871, 11328242235714328848, 3131865515489829432,
         10977756817953029463, 16137146508898304611, 7844397531750915340, 5811434156413844491,
         16395372229761246052, 11827132964039220304, 1660744670629167935, 15913214326271352414,
         8068573254449152305, 2905717078206922245, 11204220263579804010, 12035829987123708013,
         1452858539103461122, 6017914993561854006, 16189773752444600153]

}
