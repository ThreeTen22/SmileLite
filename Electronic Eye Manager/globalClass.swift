//
//  globalVars.swift
//  Electronic Eye Manager
//
//  Created by Grant on 6/7/16.
//  Copyright © 2016 Skullcup. All rights reserved.
//

import UIKit

var globalTest = 15
//                          Stock   Last  Bid 	Ask

var xonTitleData:NSArray = ["XON", 29.17, 29.14, 29.18]
//                       Date      Strk CBid CAsk  CTheo Cpos PBid PAsk PTheo PPos, PutDelta (12 total)
var xonData:NSArray =  [["06/17/16", 20, 7.4, 11.6, 9.16, 0, 0, 0.2, 0.0090191984, -81,-0.5283484502],
                        ["06/17/16", 21, 6.4, 10.6, 8.160028459, 0, 0, 0.25, 0.0192737981, 0,-1.0862216339],
                        ["06/17/16", 22, 5.5, 9.6, 7.1687611388, -10, 0, 0.25, 0.039092773, 156,-2.1141476529],
                        ["06/17/16", 23, 4.5, 8.6, 6.1974402883, 0, 0, 0.25, 0.0754634837, 0,-3.8989373447],
                        ["06/17/16", 24, 3.5, 7.6, 5.2554943743, -57, 0, 0.25, 0.1388304296, 2,-6.8095421444],
                        ["06/17/16", 24.5, 3.1, 7.2, 4.7996358271, 0, 0, 0.3, 0.1849672826, 0,-8.8136527044],
                        ["06/17/16", 25, 3.3, 5.3, 4.3565390159, 3, 0.05, 0.35, 0.2435195187, -25,-11.2470674736],
                        ["06/17/16", 25.5, 3.4, 4.7, 3.9284667429, 0, 0.05, 0.45, 0.3168068198, 0,-14.1473505873],
                        ["06/17/16", 26, 3.2, 4.3, 3.5178002348, -25, 0.1, 0.5, 0.4072583397, 50,-17.5380189061],
                        ["06/17/16", 26.5, 2.85, 3.9, 3.1269443894, 0, 0.15, 0.45, 0.517319361, 0,-21.4235662127],
                        ["06/17/16", 27, 2.45, 3.5, 2.7582134046, 18, 0.4, 0.75, 0.6493380897, 121,-25.7853403547],
                        ["06/17/16", 27.5, 2.1, 3.1, 2.4137044908, 0, 0.35, 0.95, 0.8054403372, 0,-30.5790489686],
                        ["06/17/16", 28, 1.8, 2.75, 2.0951706514, 50, 0.5, 0.95, 0.9874031174, 41,-35.7345723401],
                        ["06/17/16", 28.5, 1.5, 2.4, 1.8039055978, 0, 0.65, 1.5, 1.1965402503, 0,-41.1584973132],
                        ["06/17/16", 29, 1.25, 2.05, 1.5406540445, 61, 0.9, 1.8, 1.4336132451, 20,-46.7385379574],
                        ["06/17/16", 29.5, 1.1, 1.75, 1.305315783, 0, 1.1, 2.1, 1.698535854, 0,-52.2297262949],
                        ["06/17/16", 30, 0.85, 1.3, 1.0968779931, 192, 1.35, 2.5, 1.9903070171, -10,-57.5913229278],
                        ["06/17/16", 30.5, 0.7, 1.25, 0.9142887268, 0, 1.6, 2.8, 2.3078846147, 0,-62.7561418616],
                        ["06/17/16", 31, 0.55, 0.85, 0.7560925901, 57, 1.95, 2.85, 2.6498212331, 0,-67.6393831216],
                        ["06/17/16", 31.5, 0.4, 0.75, 0.6205050562, 0, 2.3, 3.2, 3.0143388127, 0,-72.174250501],
                        ["06/17/16", 32, 0.3, 0.45, 0.5055129131, -122, 2.6, 3.9, 3.3994293772, 0,-76.3138542174],
                        ["06/17/16", 32.5, 0.15, 0.55, 0.408974976, 0, 3, 4.2, 3.8029559774, 0,-80.0313027841],
                        ["06/17/16", 33, 0.15, 0.3, 0.3287152949, 73, 3.4, 4.6, 4.2227460874, 0,-83.3182578629],
                        ["06/17/16", 33.5, 0, 0.35, 0.2626031614, 0, 3.9, 5, 4.6566717669, 0,-86.1823603493],
                        ["06/17/16", 34, 0, 0.3, 0.2086165539, 68, 3.9, 5.5, 5.1027132318, 0,-88.6439861744],
                        ["06/17/16", 34.5, 0, 0.3, 0.1648878745, 0, 3.7, 6.4, 5.5590046931, 0,-90.7327670246],
                        ["06/17/16", 35, 0.1, 0.15, 0.1297326635, 82, 3.6, 7.8, 6.0238631544, 107,-92.4842358079],
                        ["06/17/16", 35.5, 0, 0.25, 0.101663287, 0, 4.1, 8.3, 6.4958021663, 0,-93.9368542089],
                        ["06/17/16", 36, 0, 0.25, 0.0793903475, 0, 4.5, 8.8, 6.9735332908, 0,-95.1295726816],
                        ["06/17/16", 36.5, 0, 0.25, 0.0618148417, 0, 5, 9.2, 7.4559583029, 0,-96.0999783762],
                        ["06/17/16", 37, 0, 0.25, 0.0480139836, -248, 5.5, 9.7, 7.9421550488, 0,-96.8830132737],
                        ["06/17/16", 37.5, 0, 0.25, 0.0372232606, 0, 5.9, 10.2, 8.4313595298, 0,-97.5101962321],
                        ["06/17/16", 38, 0, 0.2, 0.0288168089, 0, 6.5, 10.7, 8.922946301, 0,-98.0092569591],
                        ["06/17/16", 39, 0, 0.5, 0.0172290813, 0, 7.5, 11.7, 9.9113403798, 0,-98.7148830894],
                        ["06/17/16", 40, 0, 0.1, 0.0102964705, -115, 8.5, 12.7, 10.9043850088, 0,-99.1487566684],
                        ["06/24/16", 29.5, 1.35, 2.5, 1.6728928974, 0, 1.55, 2.65, 2.1086566211, -3,-51.1151362821],
                        ["07/15/16", 15, 12.3, 16.5, 14.16, -6, 0, 0.25, 0.0190853458, 0,-0.6850570203],
                        ["07/15/16", 20, 7.5, 11.6, 9.2451896153, 0, 0.05, 0.45, 0.214885325, 0,-6.006174176],
                        ["07/15/16", 21, 6.6, 10.8, 8.3282488267, 0, 0.1, 0.55, 0.3122944115, 0,-8.3152899554],
                        ["07/15/16", 22.5, 6.2, 8, 7.0197702268, 1, 0.25, 0.75, 0.5196426878, 0,-12.8508671587],
                        ["07/15/16", 24, 5.5, 8.1, 5.8077087662, 0, 0.5, 1.05, 0.8185090109, 0,-18.7544154931],
                        ["07/15/16", 25, 4.7, 6, 5.0620881865, -12, 0.7, 1.3, 1.0782113499, -94,-23.4342589959],
                        ["07/15/16", 26, 4.1, 5, 4.3718858695, 231, 0.95, 1.75, 1.3921419554, 0,-28.6477960367],
                        ["07/15/16", 27, 3.5, 4.3, 3.7407635925, 0, 1.35, 2.2, 1.7642068149, 0,-34.3022478605],
                        ["07/15/16", 28, 3, 3.9, 3.1711325045, -4, 1.65, 2.5, 2.1970084739, 37,-40.2736037439],
                        ["07/15/16", 29, 2.6, 3.3, 2.6639507028, 28, 2.1, 2.9, 2.6916560803, 0,-46.40888051],
                        ["07/15/16", 30, 2.2, 2.4, 2.2180480854, -1328, 3.1, 3.5, 3.2470996751, 0,-52.4475234184],
                        ["07/15/16", 31, 1.35, 2.35, 1.830717599, 95, 3.2, 4.2, 3.8607293475, 0,-58.3198500408],
                        ["07/15/16", 32, 0.95, 1.95, 1.4985015544, 4, 3.7, 4.9, 4.5291650132, 6,-63.9012078907],
                        ["07/15/16", 33, 1, 1.25, 1.2170395725, -5, 4.4, 5.5, 5.2481079504, -10,-69.0903160433],
                        ["07/15/16", 34, 0.8, 1.1, 0.9813686033, 3, 5.1, 6.4, 6.0126441547, 9,-73.8153047945],
                        ["07/15/16", 35, 0.55, 1.05, 0.7862210729, 137, 5.9, 7.1, 6.8175451076, 102,-78.0344258528],
                        ["07/15/16", 36, 0.35, 0.85, 0.6262938839, 618, 6.7, 8.3, 7.6575388446, 0,-81.7338644637],
                        ["07/15/16", 37, 0.2, 0.7, 0.496469827, -40, 7.6, 9.1, 8.5275329988, 0,-84.9234788975],
                        ["07/15/16", 38, 0.1, 0.7, 0.3919823718, 0, 8.4, 10, 9.4227808851, 0,-87.6313987342],
                        ["07/15/16", 39, 0.05, 0.5, 0.3085231447, -9, 9.1, 11.1, 10.3389900017, 0,-89.8983407583],
                        ["07/15/16", 40, 0.1, 0.4, 0.2422976157, -32, 8.9, 13, 11.2723785296, 0,-91.7723119848],
                        ["07/15/16", 41, 0, 0.35, 0.1900382822, 0, 9.9, 14, 12.2196891601, 0,-93.3041317706],
                        ["07/15/16", 42, 0, 0.5, 0.1489861325, 0, 10.7, 15, 13.1781710697, 0,-94.5439759139],
                        ["07/15/16", 43, 0, 0.25, 0.1168509173, 1, 11.7, 15.9, 14.1455405985, 0,-95.538961246],
                        ["07/15/16", 44, 0, 0.25, 0.0917593801, 60, 12.7, 16.9, 15.1199298024, -36,-96.3316643804],
                        ["07/15/16", 45, 0, 0.25, 0.072198672, 143, 13.8, 17.9, 16.0998301245, 0,-96.9594014067],
                        ["07/15/16", 46, 0, 0.25, 0.0569601544, 0, 14.7, 18.8, 17.0840364015, 0,-97.4540750363],
                        ["07/15/16", 47, 0, 0.25, 0.045086968, 0, 15.7, 19.8, 18.0715945951, 0,-97.8424070992],
                        ["07/15/16", 48, 0, 0.2, 0.0358272559, 0, 16.7, 20.8, 19.0617551434, 0,-98.146403202],
                        ["07/15/16", 49, 0, 0.15, 0.0285938194, 0, 17.7, 21.7, 20.0539327206, 0,-98.3839317111],
                        ["07/15/16", 50, 0, 0.15, 0.0229302336, 0, 18.7, 22.8, 21.0476724341, -24,-98.5693336635],
                        ["07/15/16", 55, 0, 0.1, 0.0082490536, -3, 23.7, 27.7, 26.0299290714, 0,-99.0384738341],
                        ["07/15/16", 60, 0, 0.1, 0.0034215154, 0, 28.7, 32.7, 31.0219656337, 0,-99.1790147575],
                        ["10/21/16", 20, 9.8, 11.3, 10.1266735789, 0, 0.05, 4.5, 1.4601876232, 0,-16.887246852],
                        ["10/21/16", 21, 9.1, 10.6, 9.4013469421, 0, 1.3, 2.4, 1.7504218885, 0,-19.4410795908],
                        ["10/21/16", 22, 7.6, 11.1, 8.7108743948, 0, 0.05, 4.5, 2.0730303574, 0,-22.1340500813],
                        ["10/21/16", 23, 7.7, 9.3, 8.0553457473, 0, 1.95, 2.85, 2.4285195581, 0,-24.9494692653],
                        ["10/21/16", 24, 5.9, 10, 7.4347225407, 0, 2.35, 3.3, 2.8171837473, 0,-27.8695034546],
                        ["10/21/16", 25, 6.5, 8.1, 6.8488245904, 0, 2.75, 3.7, 3.2391111337, 0,-30.8754111956],
                        ["10/21/16", 26, 4.7, 8.6, 6.2973230857, 0, 3.2, 4.2, 3.6941914681, 0,-33.9477900775],
                        ["10/21/16", 27, 5.4, 7, 5.7797388161, -4, 3.6, 4.7, 4.1821250783, 0,-37.0668356745],
                        ["10/21/16", 28, 4.9, 6.5, 5.2954445542, 0, 4.1, 5.2, 4.7024334096, 0,-40.212612248],
                        ["10/21/16", 29, 4.5, 6, 4.8436299483, 0, 4.7, 5.8, 5.254430224, 0,-43.3476811867],
                        ["10/21/16", 30, 4, 5.6, 4.4230777045, -50, 5.2, 6.4, 5.837003462, 0,-46.4426258372],
                        ["10/21/16", 31, 3.6, 5.2, 4.0326265376, -5, 5.8, 7, 6.4490811982, 0,-49.4966139229],
                        ["10/21/16", 32, 3.2, 4.8, 3.6710694754, -10, 6.4, 7.6, 7.08953238, 0,-52.4931207462],
                        ["10/21/16", 33, 3.1, 4, 3.337123148, 0, 7, 8.2, 7.7571384785, 0,-55.4172437345],
                        ["10/21/16", 34, 2.5, 4, 3.0294456135, 0, 6.3, 8.9, 8.4506131771, 0,-58.2558294738],
                        ["10/21/16", 35, 2.2, 3.7, 2.7466538022, 0, 8.4, 10.2, 9.1686213214, 0,-60.9975540017],
                        ["10/21/16", 36, 1.95, 3.4, 2.4873402124, 0, 7.7, 11.6, 9.9097968392, 0,-63.6329579846],
                        ["10/21/16", 37, 1.7, 3.1, 2.2500885545, 0, 8.5, 11.6, 10.6727593872, 0,-66.1544397185],
                        ["10/21/16", 38, 1.5, 2.85, 2.0334881124, 0, 10.4, 12, 11.4561295371, 0,-68.5562099912],
                        ["10/21/16", 39, 1.3, 2.6, 1.8361466473, 0, 11.1, 12.8, 12.2585423645, 0,-70.8342136922],
                        ["10/21/16", 40, 1.15, 2.4, 1.6567017367, 8, 12.1, 13.6, 13.0786593565, 0,-72.9860236352],
                        ["10/21/16", 41, 0.95, 2.2, 1.4938304902, 0, 12.9, 14.4, 13.915178605, 0,-75.0107123641],
                        ["10/21/16", 42, 0.85, 2.05, 1.3462576378, 0, 13.7, 15.2, 14.7668432969, 0,-76.9087077622],
                        ["10/21/16", 43, 0.7, 1.85, 1.212762028, 0, 13.3, 17, 15.6324485501, 0,-78.6816381024],
                        ["10/21/16", 44, 0.6, 1.7, 1.092181606, 0, 15.4, 17, 16.5108466807, 0,-80.3321718026],
                        ["10/21/16", 45, 0.5, 1.6, 0.9834169745, 30, 15.1, 18, 17.4009510088, 0,-81.863856622],
                        ["10/21/16", 46, 0.4, 1.45, 0.8854336581, 0, 17.2, 18.8, 18.3017383332, 0,-83.2809624068],
                        ["10/21/16", 47, 0.35, 1.35, 0.7972632067, 0, 18.1, 19.7, 19.2122502143, 0,-84.5883307955],
                        ["10/21/16", 48, 0.25, 1.25, 0.7180032812, 0, 19, 21.1, 20.131593216, 0,-85.7912345806],
                        ["10/21/16", 49, 0.2, 1.15, 0.6468168673, 0, 19.9, 22, 21.0589382537, 0,-86.8952487205],
                        ["10/21/16", 50, 0.15, 1.05, 0.5829307616, 5, 20.8, 22.6, 21.9935191959, 0,-87.9061343319],
                        ["10/21/16", 55, 0.2, 0.75, 0.3501093905, 20, 25.3, 27.7, 26.7522662347, 0,-91.7665739385],
                        ["10/21/16", 60, 0, 0.5, 0.2158653224, 4, 29.3, 33.2, 31.608693868, 0,-94.1288206405],
                        ["01/20/17", 20, 10.6, 12.3, 10.9295570929, -108, 1.95, 3.4, 2.5287788208, 0,-20.1327624336],
                        ["01/20/17", 21, 10, 11.6, 10.2898686286, 0, 2.35, 3.8, 2.9046658515, 0,-22.308679164],
                        ["01/20/17", 22.5, 8.1, 11.8, 9.3853536439, 0, 2.95, 4.1, 3.5190466993, 0,-25.6664251992],
                        ["01/20/17", 24, 8.2, 9.9, 8.5447195899, 0, 3.6, 4.8, 4.1929619514, 0,-29.110541651],
                        ["01/20/17", 25, 7.7, 9, 8.0186001448, -18, 4.1, 5.7, 4.6745659986, -1,-31.4406020854],
                        ["01/20/17", 26, 7.2, 8.9, 7.5190841471, 0, 4.5, 5.8, 5.1814343849, 0,-33.7884365223],
                        ["01/20/17", 27, 6.7, 8.5, 7.0454404373, -1, 5.1, 6.4, 5.7130049799, 0,-36.1462629718],
                        ["01/20/17", 28, 6.2, 8, 6.5969250753, 0, 5.6, 6.9, 6.268676238, 0,-38.5065503048],
                        ["01/20/17", 29, 5.9, 7.6, 6.1727318219, -10, 6.2, 7.5, 6.8477629715, 0,-40.8493400078],
                        ["01/20/17", 30, 6, 7.2, 5.7719526175, -70, 6.7, 8.1, 7.4494612402, 0,-43.1709987757],
                        ["01/20/17", 31, 4.9, 6.8, 5.3937397787, -1, 7.3, 8.7, 8.0730127567, 0,-45.4672619099],
                        ["01/20/17", 32, 4.5, 6.4, 5.037239596, 0, 8, 9.4, 8.7176411017, 0,-47.7316868006],
                        ["01/20/17", 33, 4.2, 6, 4.7015925353, 0, 8.6, 10, 9.3825539023, 0,-49.9583432259],
                        ["01/20/17", 34, 3.8, 5.7, 4.3859365444, 0, 9.3, 10.7, 10.0669477328, 0,-52.1418263429],
                        ["01/20/17", 35, 3.5, 5.4, 4.0894103759, -21, 9.9, 11.6, 10.7700127398, -1,-54.2772653766],
                        ["01/20/17", 36, 2.1, 6, 3.8111568571, 0, 10.6, 12.2, 11.490936984, 0,-56.3603277905],
                        ["01/20/17", 37, 1.9, 6, 3.5503260549, 0, 11.3, 13, 12.2289104914, 0,-58.3872188389],
                        ["01/20/17", 38, 1.5, 5.8, 3.3060782886, 0, 10.8, 13.7, 12.9831290044, 0,-60.3546765146],
                        ["01/20/17", 39, 2.4, 4.2, 3.0775869569, 0, 12.8, 14.4, 13.7527974251, 0,-62.2599620171],
                        ["01/20/17", 40, 2.2, 3.4, 2.8640411488, -50, 13.5, 15.2, 14.5371329468, 0,-64.100845966],
                        ["01/20/17", 41, 2, 3.8, 2.6646480191, 0, 14.3, 16, 15.3353678672, 0,-65.8755906692],
                        ["01/20/17", 42, 1.8, 3.5, 2.4786349123, 5, 15.1, 16.8, 16.1467520857, 0,-67.5829288325],
                        ["01/20/17", 43, 1.65, 3.3, 2.3052512266, 0, 15.9, 17.6, 16.9705552846, 0,-69.2220391504],
                        ["01/20/17", 44, 1.5, 3.1, 2.1437700132, 0, 16.7, 18.5, 17.8060688011, 0,-70.7925192618],
                        ["01/20/17", 45, 1.35, 2.95, 1.9934893123, 69, 17.5, 19.3, 18.6526071973, 0,-72.2943565772],
                        ["01/20/17", 46, 1.2, 2.75, 1.8537332299, 0, 18.4, 20.7, 19.5095095392, 0,-73.7278974961],
                        ["01/20/17", 47, 1.1, 2.6, 1.7238527639, -5, 19.2, 21.5, 20.3761403975, 0,-75.0938155268],
                        ["01/20/17", 48, 0.95, 2.45, 1.6032263903, 0, 20, 22, 21.2518905872, 0,-76.3930788072],
                        ["01/20/17", 49, 0.85, 2.3, 1.4912604239, 0, 20.9, 22.9, 22.1361776604, 0,-77.6269174936],
                        ["01/20/17", 50, 1, 2, 1.3873891682, -1, 21.8, 23.8, 23.0284461728, 0,-78.7967914535],
                        ["01/20/17", 55, 0.5, 1.55, 0.9715938276, 5, 25.3, 29.2, 27.5919523906, 0,-83.7499793255],
                        ["01/20/17", 60, 0.15, 1.25, 0.688893614, 75, 30.1, 33.8, 32.2868426638, 0,-87.403559749],
                        ["01/20/17", 65, 0.05, 1.5, 0.49730692, 1, 34.9, 38.4, 37.071751334, 0,-90.0362757556],
                        ["01/20/17", 70, 0.05, 4.5, 0.3672158882, 1, 39.7, 43.4, 41.9174851141, 0,-91.9057058316],
                        ["01/20/17", 75, 0.15, 0.6, 0.27832773, 0, 44.5, 48.2, 46.8040544806, 0,-93.2248571658],
                        ["01/20/17", 80, 0, 0.5, 0.2170144613, 0, 49.5, 53, 51.7180558756, 0,-94.1574380931],
                        ["01/20/17", 85, 0, 0.4, 0.1742314241, 0, 54.3, 58, 56.6506163408, 0,-94.8230957788],
                        ["01/20/17", 90, 0, 4.6, 0.1440037008, 0, 59.3, 63.1, 61.5958959946, 0,-95.306277047],
                        ["01/20/17", 95, 0, 0.3, 0.1223782686, 0, 64.3, 67.9, 66.5500499433, 0,-95.665145418],
                        ["01/19/18", 20, 12.5, 15.6, 13.5211678009, 0, 4.5, 6.5, 5.3643719572, -38,-21.2030651939],
                        ["01/19/18", 22.5, 11.3, 14.5, 12.3502031785, 0, 4.7, 8, 6.6930858916, 0,-24.6582388078],
                        ["01/19/18", 25, 10.3, 13.5, 11.2854612525, 0, 7, 8.4, 8.1195463057, 0,-28.0735916682],
                        ["01/19/18", 30, 7.9, 11, 9.4312251858, 0, 10, 13.2, 11.2307802951, 0,-34.7479153948],
                        ["01/19/18", 35, 6.4, 8.8, 7.8882056735, 0, 13.3, 16.4, 14.6389428354, 0,-41.1322052819],
                        ["01/19/18", 37, 6.8, 8.8, 7.3458611438, 0, 14.7, 17.8, 16.0744711924, 0,-43.5898842437],
                        ["01/19/18", 40, 6, 8, 6.6034579609, 0, 16.9, 20, 18.29690677, 0,-47.1643559916],
                        ["01/19/18", 42, 5.6, 7.6, 6.1522022671, 0, 18.4, 21.5, 19.8211788861, 0,-49.4690102166],
                        ["01/19/18", 45, 4.9, 7, 5.535030736, 0, 20.6, 24.2, 22.1661416304, 0,-52.8031721954],
                        ["01/19/18", 47, 3.5, 7.1, 5.1602952291, 0, 22.2, 25.7, 23.7655765145, 0,-54.9414987655],
                        ["01/19/18", 50, 2.9, 6.6, 4.6483848216, 0, 24.6, 28.1, 26.2143083142, 0,-58.0188859613],
                        ["01/19/18", 55, 2.3, 5.1, 3.9144195822, 0, 28.7, 32.4, 30.4138244181, 0,-62.7938779449],
                        ["01/19/18", 60, 1.7, 5, 3.3083455027, 0, 32.7, 36.6, 34.741006668, 0,-67.1232353803],
                        ["01/19/18", 65, 1.2, 4.3, 2.8089863947, 0, 37.1, 41, 39.1755173715, 0,-71.0142653678],
                        ["01/19/18", 70, 0.85, 3.8, 2.3982962354, 0, 42, 45.4, 43.6999621319, 0,-74.4849247468],
                        ["01/19/18", 75, 0.6, 3.4, 2.0609797547, 0, 46.2, 50, 48.2995574007, 0,-77.5614898928]]


func removeAfterIndex(Source str:String, CutOffIndex indx:Int) -> String {
    if str.characters.count >= indx {
        return str.stringByPaddingToLength(indx, withString: "", startingAtIndex: (str.characters.count-1))
    }
    return str
}

func isEven(i:Int)->Bool {
    if (i%2 == 0) {
        return true
    }
    return false
}
///Will prepend the appopriate amount of Zeros before a string so as to keep the character length consistant
func prependZerosToString(numberToString str:String, MinCharLength charLength:Int)-> String {
    var newStr = str
    while newStr.characters.count < (charLength) {
        newStr = "0"+newStr
    }
    return newStr
}

///Will append the appopriate amount of Zeros before a string so as to keep the character length consistant
func appendZerosToString(numberToString str:String, MinCharLength charLength:Int)-> String {
    var newStr = str
    
    while newStr.characters.count < (charLength) {
        newStr = newStr + "0"
    }
    return newStr
}


class globalClass: NSObject {

}