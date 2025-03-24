import 'dart:convert';

import 'package:example/editor/ui/pages/editor_page.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const EditorPage()));
                  },
                  color: Theme.of(context)
                      .buttonTheme
                      .colorScheme
                      ?.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  elevation: 2.0,
                  child: const Text(
                    "Go to Editor",
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                MaterialButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            EditorPage(recipeStr: jsonEncode(recipeStr))));
                  },
                  color: Theme.of(context)
                      .buttonTheme
                      .colorScheme
                      ?.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  elevation: 2.0,
                  child: const Text(
                    "Go to Editor with preloaded receipe",
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

const recipeStr = {
  "version": "1.0.0",
  "data": [
    {
      "id": "candle-1742246934276",
      "date": "2025-03-18T02:58:54.276427",
      "open": 3761.3965695335137,
      "high": 4028.555403988843,
      "low": 3577.982177543073,
      "close": 3917.3986140716047,
      "volume": 3654.793905780733,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742247834276",
      "date": "2025-03-18T03:13:54.276427",
      "open": 4021.8294766669965,
      "high": 4143.329932923236,
      "low": 4014.49716129474,
      "close": 4038.9474853768443,
      "volume": 2254.814307218653,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742248734276",
      "date": "2025-03-18T03:28:54.276427",
      "open": 4089.870296352721,
      "high": 4649.861870598901,
      "low": 4061.4857605782536,
      "close": 4442.473689725044,
      "volume": 6238.413935770783,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742249634276",
      "date": "2025-03-18T03:43:54.276427",
      "open": 4407.026144575055,
      "high": 4528.115362719899,
      "low": 4278.92487419891,
      "close": 4329.175096452033,
      "volume": 8172.15421561948,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742250534276",
      "date": "2025-03-18T03:58:54.276427",
      "open": 4384.544739206189,
      "high": 4691.756675737559,
      "low": 4318.678757924375,
      "close": 4531.644702002059,
      "volume": 1161.9436423858547,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742251434276",
      "date": "2025-03-18T04:13:54.276427",
      "open": 4450.393443677564,
      "high": 5016.5314262767615,
      "low": 4301.030472140277,
      "close": 4894.551339586293,
      "volume": 8245.573310806962,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742252334276",
      "date": "2025-03-18T04:28:54.276427",
      "open": 4920.060596168924,
      "high": 4970.384667330043,
      "low": 4505.439592530787,
      "close": 4684.959138187972,
      "volume": 4482.622922968131,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742253234276",
      "date": "2025-03-18T04:43:54.276427",
      "open": 4667.3932086068835,
      "high": 4753.250410123931,
      "low": 4614.4709165297845,
      "close": 4682.752321970951,
      "volume": 7504.4438604692605,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742254134276",
      "date": "2025-03-18T04:58:54.276427",
      "open": 4719.911151683631,
      "high": 4755.360932982242,
      "low": 4220.431930614944,
      "close": 4393.915980662467,
      "volume": 3220.897516787996,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742255034276",
      "date": "2025-03-18T05:13:54.276427",
      "open": 4304.938847481437,
      "high": 4446.7117834829005,
      "low": 3953.808541075943,
      "close": 4084.195153592299,
      "volume": 1898.3094951988478,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742255934276",
      "date": "2025-03-18T05:28:54.276427",
      "open": 4077.0459292092555,
      "high": 4311.105851829252,
      "low": 3882.1792858052972,
      "close": 4208.250468568564,
      "volume": 7893.531732754053,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742256834276",
      "date": "2025-03-18T05:43:54.276427",
      "open": 4241.335902164705,
      "high": 4384.9898094229275,
      "low": 3898.7837051913048,
      "close": 3981.176523748734,
      "volume": 1477.5846548112497,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742257734276",
      "date": "2025-03-18T05:58:54.276427",
      "open": 3930.9988409195366,
      "high": 4131.927540095468,
      "low": 3800.843687705096,
      "close": 3944.6667759754177,
      "volume": 7485.906137260313,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742258634276",
      "date": "2025-03-18T06:13:54.276427",
      "open": 3832.8755736268827,
      "high": 3962.9365140380282,
      "low": 3636.117035024627,
      "close": 3930.964437500861,
      "volume": 7763.458375025946,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742259534276",
      "date": "2025-03-18T06:28:54.276427",
      "open": 3829.323976393117,
      "high": 4311.6420590290545,
      "low": 3807.287483794887,
      "close": 4108.382383465985,
      "volume": 5583.203132313392,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742260434276",
      "date": "2025-03-18T06:43:54.276427",
      "open": 4031.397403776385,
      "high": 4416.559850039218,
      "low": 4023.007585502062,
      "close": 4256.2808273645915,
      "volume": 6022.49963221318,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742261334276",
      "date": "2025-03-18T06:58:54.276427",
      "open": 4287.798156676553,
      "high": 4619.77696270708,
      "low": 4093.790020336353,
      "close": 4547.427041611462,
      "volume": 1094.5661442802107,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742262234276",
      "date": "2025-03-18T07:13:54.276427",
      "open": 4494.111671130364,
      "high": 4804.563028868819,
      "low": 4451.60272536405,
      "close": 4582.546149257477,
      "volume": 5526.122044406448,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742263134276",
      "date": "2025-03-18T07:28:54.276427",
      "open": 4658.478422097829,
      "high": 4849.617843859837,
      "low": 4615.419354364219,
      "close": 4751.5394521001335,
      "volume": 8635.966896609401,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742264034276",
      "date": "2025-03-18T07:43:54.276427",
      "open": 4751.736810765013,
      "high": 5121.2688547486405,
      "low": 4720.309963785943,
      "close": 4964.530372469349,
      "volume": 7646.329417318213,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742264934276",
      "date": "2025-03-18T07:58:54.276427",
      "open": 4910.640216410885,
      "high": 5114.021913613213,
      "low": 4555.190261091007,
      "close": 4683.271337917371,
      "volume": 4953.992657294184,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742265834276",
      "date": "2025-03-18T08:13:54.276427",
      "open": 4578.525977666349,
      "high": 4754.4987081168865,
      "low": 4248.529079670866,
      "close": 4315.623047067888,
      "volume": 4237.624282915367,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742266734276",
      "date": "2025-03-18T08:28:54.276427",
      "open": 4216.554223711635,
      "high": 4390.761358779745,
      "low": 4043.70602589615,
      "close": 4301.573119628638,
      "volume": 3266.240686069532,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742267634276",
      "date": "2025-03-18T08:43:54.276427",
      "open": 4230.403258317998,
      "high": 4533.392867587709,
      "low": 4094.393411982985,
      "close": 4309.227513540413,
      "volume": 6968.846028903911,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742268534276",
      "date": "2025-03-18T08:58:54.276427",
      "open": 4198.588989955751,
      "high": 4237.194368406895,
      "low": 3626.792829872837,
      "close": 3801.9891339235264,
      "volume": 7043.913250883058,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742269434276",
      "date": "2025-03-18T09:13:54.276427",
      "open": 3795.9958728685456,
      "high": 3977.104391110637,
      "low": 3755.054362067195,
      "close": 3924.377177602693,
      "volume": 1540.4252575449127,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742270334276",
      "date": "2025-03-18T09:28:54.276427",
      "open": 3920.258174644153,
      "high": 4080.4243129954816,
      "low": 3435.692097610954,
      "close": 3661.7658924068246,
      "volume": 4840.736742033891,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742271234276",
      "date": "2025-03-18T09:43:54.276427",
      "open": 3655.9951960846997,
      "high": 3936.6178339418852,
      "low": 3513.6873233512183,
      "close": 3791.442075029257,
      "volume": 7323.344796320614,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742272134276",
      "date": "2025-03-18T09:58:54.276427",
      "open": 3883.7329132747736,
      "high": 4611.880286108932,
      "low": 3840.7375167774626,
      "close": 4390.061437253167,
      "volume": 9200.761354806664,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742273034276",
      "date": "2025-03-18T10:13:54.276427",
      "open": 4334.126978651489,
      "high": 4639.78381847788,
      "low": 4114.627863679898,
      "close": 4517.824294077574,
      "volume": 1953.6271916079327,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742273934276",
      "date": "2025-03-18T10:28:54.276427",
      "open": 4600.954516191996,
      "high": 4906.27749123501,
      "low": 4493.024177705258,
      "close": 4787.4560152184295,
      "volume": 7893.452213359759,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742274834276",
      "date": "2025-03-18T10:43:54.276427",
      "open": 4863.247403589904,
      "high": 4920.787903533186,
      "low": 4538.710010032481,
      "close": 4701.028933743048,
      "volume": 6302.113586100724,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742275734276",
      "date": "2025-03-18T10:58:54.276427",
      "open": 4752.150237990558,
      "high": 4815.976577215443,
      "low": 4452.1551588216025,
      "close": 4640.51342354631,
      "volume": 8210.662126096004,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742276634276",
      "date": "2025-03-18T11:13:54.276427",
      "open": 4565.930986231011,
      "high": 4759.034925578249,
      "low": 4426.807517143272,
      "close": 4588.797551845793,
      "volume": 3302.548152263052,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742277534276",
      "date": "2025-03-18T11:28:54.276427",
      "open": 4600.763170086566,
      "high": 4851.993182284042,
      "low": 4562.5861793140775,
      "close": 4666.185275570888,
      "volume": 6983.438899808362,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742278434276",
      "date": "2025-03-18T11:43:54.276427",
      "open": 4578.618121619993,
      "high": 4618.329390138044,
      "low": 4198.976830468117,
      "close": 4249.012064261202,
      "volume": 3003.0246649837973,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742279334276",
      "date": "2025-03-18T11:58:54.276427",
      "open": 4351.0041674261865,
      "high": 4534.371500130009,
      "low": 4227.543480054923,
      "close": 4401.660689594109,
      "volume": 5388.2842929104045,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742280234276",
      "date": "2025-03-18T12:13:54.276427",
      "open": 4393.855987750586,
      "high": 4436.7110029075375,
      "low": 4020.1990034773057,
      "close": 4101.863857494143,
      "volume": 3551.46618043436,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742281134276",
      "date": "2025-03-18T12:28:54.276427",
      "open": 4111.125020715322,
      "high": 4294.856580852594,
      "low": 4025.621895340956,
      "close": 4033.518174005101,
      "volume": 5668.819907642829,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742282034276",
      "date": "2025-03-18T12:43:54.276427",
      "open": 4019.719186754143,
      "high": 4101.276380536678,
      "low": 3559.4759455243393,
      "close": 3741.515506505824,
      "volume": 3805.285998710215,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742282934276",
      "date": "2025-03-18T12:58:54.276427",
      "open": 3765.6187714725434,
      "high": 4304.718065435659,
      "low": 3700.3761603040098,
      "close": 4216.125148120527,
      "volume": 7170.363870789695,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742283834276",
      "date": "2025-03-18T13:13:54.276427",
      "open": 4225.576395886775,
      "high": 4448.652690847583,
      "low": 4007.855396337121,
      "close": 4153.125952657094,
      "volume": 7424.325375906912,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742284734276",
      "date": "2025-03-18T13:28:54.276427",
      "open": 4191.862235852853,
      "high": 4304.6048999738405,
      "low": 3976.9610279411536,
      "close": 4291.464092439297,
      "volume": 9825.804138264537,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742285634276",
      "date": "2025-03-18T13:43:54.276427",
      "open": 4252.568568831339,
      "high": 4758.774141473442,
      "low": 4189.77175197586,
      "close": 4640.655254189688,
      "volume": 2731.3613766059016,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742286534276",
      "date": "2025-03-18T13:58:54.276427",
      "open": 4731.071533303479,
      "high": 5075.272563626665,
      "low": 4644.845826385434,
      "close": 4860.14883006524,
      "volume": 6482.243780432043,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742287434276",
      "date": "2025-03-18T14:13:54.276427",
      "open": 4818.011373607478,
      "high": 4913.476804803036,
      "low": 4527.202278663014,
      "close": 4690.473324788588,
      "volume": 9135.422887579789,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742288334276",
      "date": "2025-03-18T14:28:54.276427",
      "open": 4770.983168801946,
      "high": 4960.5658384306535,
      "low": 4551.5806221453095,
      "close": 4933.351406272377,
      "volume": 6602.261363939821,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742289234276",
      "date": "2025-03-18T14:43:54.276427",
      "open": 4920.44556524803,
      "high": 5204.262662931467,
      "low": 4756.515914610364,
      "close": 5027.6436404473525,
      "volume": 9380.87531563432,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742290134276",
      "date": "2025-03-18T14:58:54.276427",
      "open": 5052.677390499757,
      "high": 5194.837230718479,
      "low": 4538.338826686215,
      "close": 4602.557466341503,
      "volume": 2242.1382655284488,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742291034276",
      "date": "2025-03-18T15:13:54.276427",
      "open": 4566.183286924102,
      "high": 4777.519086426597,
      "low": 4502.5401002168555,
      "close": 4634.420400498678,
      "volume": 5033.027884751969,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742291934276",
      "date": "2025-03-18T15:28:54.276427",
      "open": 4675.473914191094,
      "high": 4728.593361711275,
      "low": 4391.100409466502,
      "close": 4505.237639390436,
      "volume": 4448.57397026683,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742292834276",
      "date": "2025-03-18T15:43:54.276427",
      "open": 4532.925724695453,
      "high": 4578.938997632683,
      "low": 4211.120271398666,
      "close": 4337.044438125172,
      "volume": 3490.1492075416486,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742293734276",
      "date": "2025-03-18T15:58:54.276427",
      "open": 4283.964163491106,
      "high": 4506.70576397711,
      "low": 3983.427746312973,
      "close": 3994.838111846546,
      "volume": 3675.1589210151033,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742294634276",
      "date": "2025-03-18T16:13:54.276427",
      "open": 3903.774520868873,
      "high": 4203.603464288928,
      "low": 3892.3625188940946,
      "close": 4079.1400184951294,
      "volume": 5601.984033996679,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742295534276",
      "date": "2025-03-18T16:28:54.276427",
      "open": 4098.301214747565,
      "high": 4101.034940763815,
      "low": 3934.5027644651705,
      "close": 4034.914767560248,
      "volume": 9821.74905077049,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742296434276",
      "date": "2025-03-18T16:43:54.276427",
      "open": 4056.4755035656126,
      "high": 4205.806142413537,
      "low": 3433.3188562036294,
      "close": 3640.861778112417,
      "volume": 1154.7721502740185,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742297334276",
      "date": "2025-03-18T16:58:54.276427",
      "open": 3581.721912613133,
      "high": 3953.0836174718297,
      "low": 3466.6323464408256,
      "close": 3762.2137320250126,
      "volume": 3733.240740354396,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742298234276",
      "date": "2025-03-18T17:13:54.276427",
      "open": 3722.831681338,
      "high": 3801.3067335670885,
      "low": 3606.452936466565,
      "close": 3673.576176333642,
      "volume": 8847.568518262013,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742299134276",
      "date": "2025-03-18T17:28:54.276427",
      "open": 3590.4206261345253,
      "high": 3660.111994207164,
      "low": 3366.4609925835384,
      "close": 3517.188238762448,
      "volume": 6286.381950616608,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742300034276",
      "date": "2025-03-18T17:43:54.276427",
      "open": 3480.2075697158966,
      "high": 3839.641879636079,
      "low": 3451.7830831117008,
      "close": 3691.097490531123,
      "volume": 6660.921984469984,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742300934276",
      "date": "2025-03-18T17:58:54.276427",
      "open": 3690.9714671972606,
      "high": 3775.215248962997,
      "low": 3564.746144647827,
      "close": 3565.791176266316,
      "volume": 5031.497094809305,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742301834276",
      "date": "2025-03-18T18:13:54.276427",
      "open": 3679.8755862183425,
      "high": 3729.795390978709,
      "low": 3443.666367265454,
      "close": 3573.801601559723,
      "volume": 6651.6200417802975,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742302734276",
      "date": "2025-03-18T18:28:54.276427",
      "open": 3663.0217796211227,
      "high": 3799.4155051757457,
      "low": 3280.8220190186253,
      "close": 3506.294075854725,
      "volume": 4104.922707383255,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742303634276",
      "date": "2025-03-18T18:43:54.276427",
      "open": 3442.411565471165,
      "high": 3707.930104064391,
      "low": 3383.21297855276,
      "close": 3663.1918601634034,
      "volume": 8569.909735204637,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742304534276",
      "date": "2025-03-18T18:58:54.276427",
      "open": 3708.039123666398,
      "high": 3727.8289140623083,
      "low": 3636.1677212153477,
      "close": 3706.5064678939702,
      "volume": 7967.262260305363,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742305434276",
      "date": "2025-03-18T19:13:54.276427",
      "open": 3752.6289841887337,
      "high": 3871.7637892213215,
      "low": 3602.602056035481,
      "close": 3708.3712308926765,
      "volume": 1681.389406037843,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742306334276",
      "date": "2025-03-18T19:28:54.276427",
      "open": 3769.056781408902,
      "high": 3990.1906902643427,
      "low": 3598.505772331265,
      "close": 3708.0039457464445,
      "volume": 7007.2353318617625,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742307234276",
      "date": "2025-03-18T19:43:54.276427",
      "open": 3630.4057248575955,
      "high": 4131.2447714115315,
      "low": 3445.5394322707107,
      "close": 3940.966531661668,
      "volume": 9138.150616841993,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742308134276",
      "date": "2025-03-18T19:58:54.276427",
      "open": 3856.156960479933,
      "high": 4607.028657630335,
      "low": 3808.6390787233345,
      "close": 4376.336838581149,
      "volume": 1529.917052659134,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742309034276",
      "date": "2025-03-18T20:13:54.276427",
      "open": 4324.524456641089,
      "high": 4690.6824940236265,
      "low": 4178.7815546814745,
      "close": 4563.364392252026,
      "volume": 6687.295487370137,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742309934276",
      "date": "2025-03-18T20:28:54.276427",
      "open": 4668.916485998768,
      "high": 5055.680932114986,
      "low": 4458.319902037239,
      "close": 4904.307977440456,
      "volume": 7825.987676442733,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742310834276",
      "date": "2025-03-18T20:43:54.276427",
      "open": 4806.7261173121615,
      "high": 5269.539760569499,
      "low": 4768.714146644309,
      "close": 5135.489992433559,
      "volume": 3373.044456514387,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742311734276",
      "date": "2025-03-18T20:58:54.276427",
      "open": 5072.681245862423,
      "high": 5357.9478391288985,
      "low": 4992.906114740965,
      "close": 5355.936740384071,
      "volume": 5223.456542246822,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742312634276",
      "date": "2025-03-18T21:13:54.276427",
      "open": 5430.85768827557,
      "high": 5577.886034131191,
      "low": 5178.66786985671,
      "close": 5258.836897728501,
      "volume": 8553.935959615234,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742313534276",
      "date": "2025-03-18T21:28:54.276427",
      "open": 5327.121184932763,
      "high": 5551.263229699638,
      "low": 5170.822820509073,
      "close": 5181.1231525031035,
      "volume": 4095.965993924935,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742314434276",
      "date": "2025-03-18T21:43:54.276427",
      "open": 5132.32504250093,
      "high": 5733.552754049201,
      "low": 5009.842562426138,
      "close": 5576.3250332879625,
      "volume": 7674.218567914863,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742315334276",
      "date": "2025-03-18T21:58:54.276427",
      "open": 5496.152216046526,
      "high": 5544.1018187393465,
      "low": 5251.46565930702,
      "close": 5356.113936596263,
      "volume": 6240.671368173855,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742316234276",
      "date": "2025-03-18T22:13:54.276427",
      "open": 5343.109644693398,
      "high": 5625.066121881267,
      "low": 5337.606362934008,
      "close": 5623.809466882072,
      "volume": 1631.3201820087374,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742317134276",
      "date": "2025-03-18T22:28:54.276427",
      "open": 5620.7020958845615,
      "high": 5707.187685593348,
      "low": 5234.5642648405965,
      "close": 5460.595397681079,
      "volume": 9600.21712297814,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742318034276",
      "date": "2025-03-18T22:43:54.276427",
      "open": 5534.609765792943,
      "high": 5791.598748487199,
      "low": 5482.878372740803,
      "close": 5753.75905174989,
      "volume": 6663.037812964005,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742318934276",
      "date": "2025-03-18T22:58:54.276427",
      "open": 5670.42650999853,
      "high": 5871.900684301833,
      "low": 5232.434607758715,
      "close": 5438.286765780136,
      "volume": 5847.402853296198,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742319834276",
      "date": "2025-03-18T23:13:54.276427",
      "open": 5471.767643377504,
      "high": 5486.772887339213,
      "low": 5363.908987368096,
      "close": 5389.493398070336,
      "volume": 1011.500667739703,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742320734276",
      "date": "2025-03-18T23:28:54.276427",
      "open": 5387.578689881106,
      "high": 5429.435395627233,
      "low": 5045.869531423684,
      "close": 5161.855411279304,
      "volume": 2894.485484134111,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742321634276",
      "date": "2025-03-18T23:43:54.276427",
      "open": 5236.285035801522,
      "high": 5568.714683015519,
      "low": 5198.670655308303,
      "close": 5392.217125095727,
      "volume": 6698.235540149918,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742322534276",
      "date": "2025-03-18T23:58:54.276427",
      "open": 5457.294812614377,
      "high": 5637.9015641800315,
      "low": 5242.9398137370845,
      "close": 5259.889256876541,
      "volume": 4776.330068464305,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742323434276",
      "date": "2025-03-19T00:13:54.276427",
      "open": 5275.331385658561,
      "high": 5413.257445461323,
      "low": 4939.620990794048,
      "close": 4958.9961700463655,
      "volume": 4232.953397451418,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742324334276",
      "date": "2025-03-19T00:28:54.276427",
      "open": 4962.696812186544,
      "high": 5253.9532138378,
      "low": 4892.6260593018,
      "close": 5126.788930682412,
      "volume": 3525.811211236808,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742325234276",
      "date": "2025-03-19T00:43:54.276427",
      "open": 5058.349636210842,
      "high": 5451.527922843241,
      "low": 4842.570237587381,
      "close": 5329.696022672426,
      "volume": 4925.20016942841,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742326134276",
      "date": "2025-03-19T00:58:54.276427",
      "open": 5421.621794605653,
      "high": 5652.910629509766,
      "low": 5231.281818341588,
      "close": 5409.370289840201,
      "volume": 9689.28595875641,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742327034276",
      "date": "2025-03-19T01:13:54.276427",
      "open": 5327.456733377344,
      "high": 5516.7896424014125,
      "low": 5313.698826458821,
      "close": 5332.316890142794,
      "volume": 9419.21454867034,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742327934276",
      "date": "2025-03-19T01:28:54.276427",
      "open": 5350.054212716699,
      "high": 5717.859243310058,
      "low": 5121.82559374457,
      "close": 5630.339244887492,
      "volume": 6704.444376932169,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742328834276",
      "date": "2025-03-19T01:43:54.276427",
      "open": 5702.033501765818,
      "high": 5876.182527870439,
      "low": 5426.649965994707,
      "close": 5553.78804655668,
      "volume": 5304.62941813777,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742329734276",
      "date": "2025-03-19T01:58:54.276427",
      "open": 5541.329333546983,
      "high": 5644.779377639221,
      "low": 5432.322764542964,
      "close": 5531.342425948539,
      "volume": 7917.770354491147,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742330634276",
      "date": "2025-03-19T02:13:54.276427",
      "open": 5637.36113665637,
      "high": 5768.214453975804,
      "low": 5380.950846221289,
      "close": 5613.20961352205,
      "volume": 4432.777638801179,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742331534276",
      "date": "2025-03-19T02:28:54.276427",
      "open": 5507.343755940116,
      "high": 5672.983493129953,
      "low": 5500.82738621869,
      "close": 5510.621131632029,
      "volume": 7443.197973543082,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742332434276",
      "date": "2025-03-19T02:43:54.276427",
      "open": 5528.232262884756,
      "high": 5748.352498250469,
      "low": 5467.200485928126,
      "close": 5521.163636559822,
      "volume": 8364.883881454887,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742333334276",
      "date": "2025-03-19T02:58:54.276427",
      "open": 5491.387875014467,
      "high": 5966.349461448639,
      "low": 5482.487208217197,
      "close": 5856.259356268755,
      "volume": 1859.911357271746,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742334234276",
      "date": "2025-03-19T03:13:54.276427",
      "open": 5797.786304175255,
      "high": 6085.343712883877,
      "low": 5567.265714239242,
      "close": 6029.415627234726,
      "volume": 1497.1912292245129,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742335134276",
      "date": "2025-03-19T03:28:54.276427",
      "open": 5967.178582591609,
      "high": 6186.587285460423,
      "low": 5646.596227532206,
      "close": 5874.2705126977835,
      "volume": 7986.974430100118,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742336034276",
      "date": "2025-03-19T03:43:54.276427",
      "open": 5909.041708394412,
      "high": 6047.980600211878,
      "low": 5745.556441889315,
      "close": 6013.447211217947,
      "volume": 1531.07378709058,
      "promptText": null,
      "state": "natural"
    }
  ],
  "chartSettings": {
    "dataFit": "adaptiveWidth",
    "yAxisSettings": {
      "axisTextStyle": {
        "color": "#ff000000",
        "fontSize": 12.0,
        "fontWeight": "w400"
      },
      "strokeWidth": 1.0,
      "axisColor": "#ff000000",
      "yAxisPos": "right"
    },
    "xAxisSettings": {
      "axisTextStyle": {
        "color": "#ff000000",
        "fontSize": 12.0,
        "fontWeight": "w400"
      },
      "strokeWidth": 1.0,
      "axisColor": "#ff000000",
      "xAxisPos": "bottom"
    },
    "mainPlotRegionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
  },
  "tasks": [
    {
      "id": "5c28cf81-d747-4d42-9615-602b955618eb",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Let’s learn about support and resistance.",
      "isExplanation": false
    },
    {
      "id": "870b5584-255d-41a7-8187-048395dbcfa4",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "13dc84c4-9f3a-492f-b781-4cfc5e531448",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Click on a button to load data",
      "isExplanation": false
    },
    {
      "id": "8484d4d1-4474-4544-8a05-11a90feb092f",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Let's Go"
    },
    {
      "id": "76175d33-ed80-457f-8b86-8721c884bd8b",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 0,
      "tillPoint": 18
    },
    {
      "id": "43bb2e4c-fb52-4fd6-bc20-f8337dcb44bd",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Move the circle to candle from where price is moving in downward direction",
      "isExplanation": false
    },
    {
      "id": "c887590c-ac43-4cef-8f4d-3960da85bd74",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "024f5ede-ddab-4d63-b049-65c40f37b2c3",
        "type": "circularArea",
        "isLocked": false,
        "isSelectd": false,
        "point": {"dx": 6.0, "dy": 3974.8095379311735},
        "radius": 20.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "be39a617-7aea-486b-8129-38b5fa29e2c2",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "0206c1e3-d48c-42b0-9c68-e5641093599b",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "4d1c8199-51e6-45f0-a09a-d9f1f94fc8a2",
        "type": "circularArea",
        "isLocked": true,
        "isSelectd": false,
        "point": {"dx": 6.0, "dy": 4983.850820769795},
        "radius": 50.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "a1e4d7e5-c3b5-4bb5-80dc-c72da01436dd",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Green circle shows the correct answer!\nHope you got it right!!",
      "isExplanation": true
    },
    {
      "id": "2a4ad4bc-9bca-4597-8082-2cefb1757d94",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "dd5f5d24-c1af-4469-9fe8-043d559f41f6",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Can you find a point from which price is bouncing back?\nDrag the blue circle to that point",
      "isExplanation": false
    },
    {
      "id": "358098f6-26dd-4721-b05c-afedab0de6fe",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "8f3069d4-0e59-4e58-824a-9098a438ee63",
        "type": "circularArea",
        "isLocked": false,
        "isSelectd": false,
        "point": {"dx": 14.0, "dy": 4816.672383376414},
        "radius": 20.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "a6dd94eb-cd9f-448c-80d3-0db6219a5032",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "04e134ad-2dc8-4dc2-bfe2-44ce564c629b",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "c89690e7-4392-4c84-b092-3c9d753f3d97",
        "type": "circularArea",
        "isLocked": true,
        "isSelectd": false,
        "point": {"dx": 14.0, "dy": 3817.5822283700236},
        "radius": 50.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "05a1826c-c29d-4d8b-b99b-5f116a7b93c0",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Hope you got that also right!!\nLet’s add more data",
      "isExplanation": true
    },
    {
      "id": "bb2bb33d-b37c-4f55-a1bd-0b6e4034099d",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "10c35144-8443-49ef-b001-01fc87a78547",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 18,
      "tillPoint": 42
    },
    {
      "id": "f4bc71db-6175-4d51-8401-16d48f33b0e4",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "e43c84ec-b8c6-4040-bf67-2bc04569a44a",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "When stock struggles to cross particulate price range it is called resistance.",
      "isExplanation": false
    },
    {
      "id": "7492d06b-b0ea-4464-97e2-40f2f5e96f5d",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "e0ed14c6-1cb4-40a6-8e38-eca0bf46ba48",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Price from which stock bounces back is called support line",
      "isExplanation": false
    },
    {
      "id": "723b2731-3f24-4571-8519-40aee8e13635",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Got it"
    },
    {
      "id": "a2eac438-898e-479f-b055-198d5a4c3058",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Let’s adjust support and resistance line in given chart",
      "isExplanation": false
    },
    {
      "id": "c86ef478-7db1-47f0-9752-62bb618bf31c",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "e075fcc5-f18a-4a0a-9509-57a16693a029",
        "type": "horizontalLine",
        "isLocked": false,
        "isSelectd": false,
        "value": 4450.471935968521,
        "color": "#ff4caf50",
        "strokeWidth": 2.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "a2484456-c165-42a5-8e7a-28c4ba6fb56a",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "b05d63ca-696f-497c-b146-8a7f771a2419",
        "type": "horizontalLine",
        "isLocked": false,
        "isSelectd": false,
        "value": 4281.303309450699,
        "color": "#fff44336",
        "strokeWidth": 2.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "ed200f41-0776-48e0-8024-ccd12c04948b",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "1008761b-51c0-45c3-a3cd-6ad232d1a33a",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "d0429ec1-3a14-4341-af92-8b2f9254631e",
        "type": "horizontalBand",
        "isLocked": false,
        "isSelectd": false,
        "value": 5055.498722509816,
        "allowedError": 40.0,
        "color": "#fff44336"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "82217ad2-1a9b-42a5-881d-422bb5f43a5c",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "247e5922-7544-40c4-af30-950edf340bee",
        "type": "horizontalBand",
        "isLocked": false,
        "isSelectd": false,
        "value": 3805.6409114133535,
        "allowedError": 40.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "b0ab8ae8-e37d-450e-950f-c7dbc1bc7c92",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Your red line must in red region and green line must be in green region.",
      "isExplanation": true
    },
    {
      "id": "ac202aa4-8d1f-4e32-95f9-b0ff9b6baac0",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Got it"
    },
    {
      "id": "4633b6ea-70d3-4497-915b-2da7c79b9799",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 42,
      "tillPoint": 76
    },
    {
      "id": "c92bd956-c973-4f85-b451-4c2891634226",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "464db97b-f96b-4e8a-8693-f4301d949f79",
        "type": "label",
        "isLocked": false,
        "isSelectd": false,
        "pos": {"dx": 41.0, "dy": 5389.855597296578},
        "label": "Resistance",
        "textColor": "#fff44336",
        "fontSize": 27.0,
        "fontWeight": "bold"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "aec63b53-f86f-45f5-8f01-9cc14a7b1989",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "84ce3a46-c111-4a37-a996-f9bad1a25b5a",
        "type": "label",
        "isLocked": false,
        "isSelectd": false,
        "pos": {"dx": 60.0, "dy": 5801.831032301696},
        "label": "Support",
        "textColor": "#ff4caf50",
        "fontSize": 20.0,
        "fontWeight": "normal"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "eef31d0e-0fb5-4915-8e8a-caad61a3e01c",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "0b2b5304-bee8-4aa5-a13c-b267c640762b",
        "type": "arrow",
        "isLocked": false,
        "isSelectd": false,
        "from": {"dx": 62.0, "dy": 5620.721088827206},
        "to": {"dx": 62.0, "dy": 3851.415899010576},
        "strokeWidth": 2.0,
        "arrowheadSize": 15.0,
        "endPointRadius": 5.0,
        "color": "#ff4caf50",
        "isArrowheadAtTo": true
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "4cd5df8a-0fb3-4507-8478-52eeb5a5c3f0",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "e81699f5-8064-4192-bec6-dda7ae46c27c",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 76,
      "tillPoint": 100
    },
    {
      "id": "0625a1b5-63d7-4134-81da-4b26d16238a1",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Let's Go"
    },
    {
      "id": "efc1b490-e105-4646-8aef-f0252b22720c",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "91c886e7-13cd-4dc1-b0b4-e0818848af87",
        "type": "rectArea",
        "isLocked": false,
        "isSelectd": false,
        "topLeft": {"dx": 76.0, "dy": 5863.527806209484},
        "topRight": {"dx": 88.0, "dy": 5863.527806209484},
        "bottomLeft": {"dx": 76.0, "dy": 4745.024481636391},
        "bottomRight": {"dx": 88.0, "dy": 4745.024481636391},
        "color": "#ffffc107",
        "strokeWidth": 2.0,
        "alpha": 51,
        "endPointRadius": 5.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "4a464a39-6f72-48a5-b1ea-18e08fea1d5f",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "d1b73194-46ef-4d8b-ad28-6d0befe5e879",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "b86e32c5-4d8c-4a10-be5c-c5c90388bfa8",
        "type": "trendLine",
        "isLocked": false,
        "isSelectd": false,
        "from": {"dx": 88.0, "dy": 4116.115152286776},
        "to": {"dx": 95.0, "dy": 5324.1783540348915},
        "strokeWidth": 2.0,
        "endPointRadius": 5.0,
        "color": "#ff000000"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "c352bd05-19aa-4f2b-9d4a-b35f88b256fc",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Check"
    },
    {
      "id": "23fbec90-2ce7-4a66-b34f-b214e594dcff",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "a109a882-7449-4ae4-9a79-1a8384fc7f50",
        "type": "parallelChannel",
        "isLocked": true,
        "isSelectd": true,
        "topLeft": {"dx": 88.80000000000001, "dy": 4727.1125973064145},
        "topRight": {"dx": 98.88333282470707, "dy": 5837.655074276744},
        "bottomLeft": {"dx": 88.80000000000001, "dy": 5497.327449906629},
        "bottomRight": {"dx": 98.88333282470707, "dy": 6607.869926876959},
        "strokeWidth": 2.0,
        "channelAlpha": 51,
        "endPointRadius": 5.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    }
  ]
};

const newData = {
  "version": "1.0.0",
  "data": [
    {
      "id": "candle-1742246934276",
      "date": "2025-03-18T02:58:54.276427",
      "open": 3761.3965695335137,
      "high": 4028.555403988843,
      "low": 3577.982177543073,
      "close": 3917.3986140716047,
      "volume": 3654.793905780733,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742247834276",
      "date": "2025-03-18T03:13:54.276427",
      "open": 4021.8294766669965,
      "high": 4143.329932923236,
      "low": 4014.49716129474,
      "close": 4038.9474853768443,
      "volume": 2254.814307218653,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742248734276",
      "date": "2025-03-18T03:28:54.276427",
      "open": 4089.870296352721,
      "high": 4649.861870598901,
      "low": 4061.4857605782536,
      "close": 4442.473689725044,
      "volume": 6238.413935770783,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742249634276",
      "date": "2025-03-18T03:43:54.276427",
      "open": 4407.026144575055,
      "high": 4528.115362719899,
      "low": 4278.92487419891,
      "close": 4329.175096452033,
      "volume": 8172.15421561948,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742250534276",
      "date": "2025-03-18T03:58:54.276427",
      "open": 4384.544739206189,
      "high": 4691.756675737559,
      "low": 4318.678757924375,
      "close": 4531.644702002059,
      "volume": 1161.9436423858547,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742251434276",
      "date": "2025-03-18T04:13:54.276427",
      "open": 4450.393443677564,
      "high": 5016.5314262767615,
      "low": 4301.030472140277,
      "close": 4894.551339586293,
      "volume": 8245.573310806962,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742252334276",
      "date": "2025-03-18T04:28:54.276427",
      "open": 4920.060596168924,
      "high": 4970.384667330043,
      "low": 4505.439592530787,
      "close": 4684.959138187972,
      "volume": 4482.622922968131,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742253234276",
      "date": "2025-03-18T04:43:54.276427",
      "open": 4667.3932086068835,
      "high": 4753.250410123931,
      "low": 4614.4709165297845,
      "close": 4682.752321970951,
      "volume": 7504.4438604692605,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742254134276",
      "date": "2025-03-18T04:58:54.276427",
      "open": 4719.911151683631,
      "high": 4755.360932982242,
      "low": 4220.431930614944,
      "close": 4393.915980662467,
      "volume": 3220.897516787996,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742255034276",
      "date": "2025-03-18T05:13:54.276427",
      "open": 4304.938847481437,
      "high": 4446.7117834829005,
      "low": 3953.808541075943,
      "close": 4084.195153592299,
      "volume": 1898.3094951988478,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742255934276",
      "date": "2025-03-18T05:28:54.276427",
      "open": 4077.0459292092555,
      "high": 4311.105851829252,
      "low": 3882.1792858052972,
      "close": 4208.250468568564,
      "volume": 7893.531732754053,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742256834276",
      "date": "2025-03-18T05:43:54.276427",
      "open": 4241.335902164705,
      "high": 4384.9898094229275,
      "low": 3898.7837051913048,
      "close": 3981.176523748734,
      "volume": 1477.5846548112497,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742257734276",
      "date": "2025-03-18T05:58:54.276427",
      "open": 3930.9988409195366,
      "high": 4131.927540095468,
      "low": 3800.843687705096,
      "close": 3944.6667759754177,
      "volume": 7485.906137260313,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742258634276",
      "date": "2025-03-18T06:13:54.276427",
      "open": 3832.8755736268827,
      "high": 3962.9365140380282,
      "low": 3636.117035024627,
      "close": 3930.964437500861,
      "volume": 7763.458375025946,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742259534276",
      "date": "2025-03-18T06:28:54.276427",
      "open": 3829.323976393117,
      "high": 4311.6420590290545,
      "low": 3807.287483794887,
      "close": 4108.382383465985,
      "volume": 5583.203132313392,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742260434276",
      "date": "2025-03-18T06:43:54.276427",
      "open": 4031.397403776385,
      "high": 4416.559850039218,
      "low": 4023.007585502062,
      "close": 4256.2808273645915,
      "volume": 6022.49963221318,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742261334276",
      "date": "2025-03-18T06:58:54.276427",
      "open": 4287.798156676553,
      "high": 4619.77696270708,
      "low": 4093.790020336353,
      "close": 4547.427041611462,
      "volume": 1094.5661442802107,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742262234276",
      "date": "2025-03-18T07:13:54.276427",
      "open": 4494.111671130364,
      "high": 4804.563028868819,
      "low": 4451.60272536405,
      "close": 4582.546149257477,
      "volume": 5526.122044406448,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742263134276",
      "date": "2025-03-18T07:28:54.276427",
      "open": 4658.478422097829,
      "high": 4849.617843859837,
      "low": 4615.419354364219,
      "close": 4751.5394521001335,
      "volume": 8635.966896609401,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742264034276",
      "date": "2025-03-18T07:43:54.276427",
      "open": 4751.736810765013,
      "high": 5121.2688547486405,
      "low": 4720.309963785943,
      "close": 4964.530372469349,
      "volume": 7646.329417318213,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742264934276",
      "date": "2025-03-18T07:58:54.276427",
      "open": 4910.640216410885,
      "high": 5114.021913613213,
      "low": 4555.190261091007,
      "close": 4683.271337917371,
      "volume": 4953.992657294184,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742265834276",
      "date": "2025-03-18T08:13:54.276427",
      "open": 4578.525977666349,
      "high": 4754.4987081168865,
      "low": 4248.529079670866,
      "close": 4315.623047067888,
      "volume": 4237.624282915367,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742266734276",
      "date": "2025-03-18T08:28:54.276427",
      "open": 4216.554223711635,
      "high": 4390.761358779745,
      "low": 4043.70602589615,
      "close": 4301.573119628638,
      "volume": 3266.240686069532,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742267634276",
      "date": "2025-03-18T08:43:54.276427",
      "open": 4230.403258317998,
      "high": 4533.392867587709,
      "low": 4094.393411982985,
      "close": 4309.227513540413,
      "volume": 6968.846028903911,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742268534276",
      "date": "2025-03-18T08:58:54.276427",
      "open": 4198.588989955751,
      "high": 4237.194368406895,
      "low": 3626.792829872837,
      "close": 3801.9891339235264,
      "volume": 7043.913250883058,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742269434276",
      "date": "2025-03-18T09:13:54.276427",
      "open": 3795.9958728685456,
      "high": 3977.104391110637,
      "low": 3755.054362067195,
      "close": 3924.377177602693,
      "volume": 1540.4252575449127,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742270334276",
      "date": "2025-03-18T09:28:54.276427",
      "open": 3920.258174644153,
      "high": 4080.4243129954816,
      "low": 3435.692097610954,
      "close": 3661.7658924068246,
      "volume": 4840.736742033891,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742271234276",
      "date": "2025-03-18T09:43:54.276427",
      "open": 3655.9951960846997,
      "high": 3936.6178339418852,
      "low": 3513.6873233512183,
      "close": 3791.442075029257,
      "volume": 7323.344796320614,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742272134276",
      "date": "2025-03-18T09:58:54.276427",
      "open": 3883.7329132747736,
      "high": 4611.880286108932,
      "low": 3840.7375167774626,
      "close": 4390.061437253167,
      "volume": 9200.761354806664,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742273034276",
      "date": "2025-03-18T10:13:54.276427",
      "open": 4334.126978651489,
      "high": 4639.78381847788,
      "low": 4114.627863679898,
      "close": 4517.824294077574,
      "volume": 1953.6271916079327,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742273934276",
      "date": "2025-03-18T10:28:54.276427",
      "open": 4600.954516191996,
      "high": 4906.27749123501,
      "low": 4493.024177705258,
      "close": 4787.4560152184295,
      "volume": 7893.452213359759,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742274834276",
      "date": "2025-03-18T10:43:54.276427",
      "open": 4863.247403589904,
      "high": 4920.787903533186,
      "low": 4538.710010032481,
      "close": 4701.028933743048,
      "volume": 6302.113586100724,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742275734276",
      "date": "2025-03-18T10:58:54.276427",
      "open": 4752.150237990558,
      "high": 4815.976577215443,
      "low": 4452.1551588216025,
      "close": 4640.51342354631,
      "volume": 8210.662126096004,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742276634276",
      "date": "2025-03-18T11:13:54.276427",
      "open": 4565.930986231011,
      "high": 4759.034925578249,
      "low": 4426.807517143272,
      "close": 4588.797551845793,
      "volume": 3302.548152263052,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742277534276",
      "date": "2025-03-18T11:28:54.276427",
      "open": 4600.763170086566,
      "high": 4851.993182284042,
      "low": 4562.5861793140775,
      "close": 4666.185275570888,
      "volume": 6983.438899808362,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742278434276",
      "date": "2025-03-18T11:43:54.276427",
      "open": 4578.618121619993,
      "high": 4618.329390138044,
      "low": 4198.976830468117,
      "close": 4249.012064261202,
      "volume": 3003.0246649837973,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742279334276",
      "date": "2025-03-18T11:58:54.276427",
      "open": 4351.0041674261865,
      "high": 4534.371500130009,
      "low": 4227.543480054923,
      "close": 4401.660689594109,
      "volume": 5388.2842929104045,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742280234276",
      "date": "2025-03-18T12:13:54.276427",
      "open": 4393.855987750586,
      "high": 4436.7110029075375,
      "low": 4020.1990034773057,
      "close": 4101.863857494143,
      "volume": 3551.46618043436,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742281134276",
      "date": "2025-03-18T12:28:54.276427",
      "open": 4111.125020715322,
      "high": 4294.856580852594,
      "low": 4025.621895340956,
      "close": 4033.518174005101,
      "volume": 5668.819907642829,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742282034276",
      "date": "2025-03-18T12:43:54.276427",
      "open": 4019.719186754143,
      "high": 4101.276380536678,
      "low": 3559.4759455243393,
      "close": 3741.515506505824,
      "volume": 3805.285998710215,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742282934276",
      "date": "2025-03-18T12:58:54.276427",
      "open": 3765.6187714725434,
      "high": 4304.718065435659,
      "low": 3700.3761603040098,
      "close": 4216.125148120527,
      "volume": 7170.363870789695,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742283834276",
      "date": "2025-03-18T13:13:54.276427",
      "open": 4225.576395886775,
      "high": 4448.652690847583,
      "low": 4007.855396337121,
      "close": 4153.125952657094,
      "volume": 7424.325375906912,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742284734276",
      "date": "2025-03-18T13:28:54.276427",
      "open": 4191.862235852853,
      "high": 4304.6048999738405,
      "low": 3976.9610279411536,
      "close": 4291.464092439297,
      "volume": 9825.804138264537,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742285634276",
      "date": "2025-03-18T13:43:54.276427",
      "open": 4252.568568831339,
      "high": 4758.774141473442,
      "low": 4189.77175197586,
      "close": 4640.655254189688,
      "volume": 2731.3613766059016,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742286534276",
      "date": "2025-03-18T13:58:54.276427",
      "open": 4731.071533303479,
      "high": 5075.272563626665,
      "low": 4644.845826385434,
      "close": 4860.14883006524,
      "volume": 6482.243780432043,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742287434276",
      "date": "2025-03-18T14:13:54.276427",
      "open": 4818.011373607478,
      "high": 4913.476804803036,
      "low": 4527.202278663014,
      "close": 4690.473324788588,
      "volume": 9135.422887579789,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742288334276",
      "date": "2025-03-18T14:28:54.276427",
      "open": 4770.983168801946,
      "high": 4960.5658384306535,
      "low": 4551.5806221453095,
      "close": 4933.351406272377,
      "volume": 6602.261363939821,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742289234276",
      "date": "2025-03-18T14:43:54.276427",
      "open": 4920.44556524803,
      "high": 5204.262662931467,
      "low": 4756.515914610364,
      "close": 5027.6436404473525,
      "volume": 9380.87531563432,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742290134276",
      "date": "2025-03-18T14:58:54.276427",
      "open": 5052.677390499757,
      "high": 5194.837230718479,
      "low": 4538.338826686215,
      "close": 4602.557466341503,
      "volume": 2242.1382655284488,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742291034276",
      "date": "2025-03-18T15:13:54.276427",
      "open": 4566.183286924102,
      "high": 4777.519086426597,
      "low": 4502.5401002168555,
      "close": 4634.420400498678,
      "volume": 5033.027884751969,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742291934276",
      "date": "2025-03-18T15:28:54.276427",
      "open": 4675.473914191094,
      "high": 4728.593361711275,
      "low": 4391.100409466502,
      "close": 4505.237639390436,
      "volume": 4448.57397026683,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742292834276",
      "date": "2025-03-18T15:43:54.276427",
      "open": 4532.925724695453,
      "high": 4578.938997632683,
      "low": 4211.120271398666,
      "close": 4337.044438125172,
      "volume": 3490.1492075416486,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742293734276",
      "date": "2025-03-18T15:58:54.276427",
      "open": 4283.964163491106,
      "high": 4506.70576397711,
      "low": 3983.427746312973,
      "close": 3994.838111846546,
      "volume": 3675.1589210151033,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742294634276",
      "date": "2025-03-18T16:13:54.276427",
      "open": 3903.774520868873,
      "high": 4203.603464288928,
      "low": 3892.3625188940946,
      "close": 4079.1400184951294,
      "volume": 5601.984033996679,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742295534276",
      "date": "2025-03-18T16:28:54.276427",
      "open": 4098.301214747565,
      "high": 4101.034940763815,
      "low": 3934.5027644651705,
      "close": 4034.914767560248,
      "volume": 9821.74905077049,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742296434276",
      "date": "2025-03-18T16:43:54.276427",
      "open": 4056.4755035656126,
      "high": 4205.806142413537,
      "low": 3433.3188562036294,
      "close": 3640.861778112417,
      "volume": 1154.7721502740185,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742297334276",
      "date": "2025-03-18T16:58:54.276427",
      "open": 3581.721912613133,
      "high": 3953.0836174718297,
      "low": 3466.6323464408256,
      "close": 3762.2137320250126,
      "volume": 3733.240740354396,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742298234276",
      "date": "2025-03-18T17:13:54.276427",
      "open": 3722.831681338,
      "high": 3801.3067335670885,
      "low": 3606.452936466565,
      "close": 3673.576176333642,
      "volume": 8847.568518262013,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742299134276",
      "date": "2025-03-18T17:28:54.276427",
      "open": 3590.4206261345253,
      "high": 3660.111994207164,
      "low": 3366.4609925835384,
      "close": 3517.188238762448,
      "volume": 6286.381950616608,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742300034276",
      "date": "2025-03-18T17:43:54.276427",
      "open": 3480.2075697158966,
      "high": 3839.641879636079,
      "low": 3451.7830831117008,
      "close": 3691.097490531123,
      "volume": 6660.921984469984,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742300934276",
      "date": "2025-03-18T17:58:54.276427",
      "open": 3690.9714671972606,
      "high": 3775.215248962997,
      "low": 3564.746144647827,
      "close": 3565.791176266316,
      "volume": 5031.497094809305,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742301834276",
      "date": "2025-03-18T18:13:54.276427",
      "open": 3679.8755862183425,
      "high": 3729.795390978709,
      "low": 3443.666367265454,
      "close": 3573.801601559723,
      "volume": 6651.6200417802975,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742302734276",
      "date": "2025-03-18T18:28:54.276427",
      "open": 3663.0217796211227,
      "high": 3799.4155051757457,
      "low": 3280.8220190186253,
      "close": 3506.294075854725,
      "volume": 4104.922707383255,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742303634276",
      "date": "2025-03-18T18:43:54.276427",
      "open": 3442.411565471165,
      "high": 3707.930104064391,
      "low": 3383.21297855276,
      "close": 3663.1918601634034,
      "volume": 8569.909735204637,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742304534276",
      "date": "2025-03-18T18:58:54.276427",
      "open": 3708.039123666398,
      "high": 3727.8289140623083,
      "low": 3636.1677212153477,
      "close": 3706.5064678939702,
      "volume": 7967.262260305363,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742305434276",
      "date": "2025-03-18T19:13:54.276427",
      "open": 3752.6289841887337,
      "high": 3871.7637892213215,
      "low": 3602.602056035481,
      "close": 3708.3712308926765,
      "volume": 1681.389406037843,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742306334276",
      "date": "2025-03-18T19:28:54.276427",
      "open": 3769.056781408902,
      "high": 3990.1906902643427,
      "low": 3598.505772331265,
      "close": 3708.0039457464445,
      "volume": 7007.2353318617625,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742307234276",
      "date": "2025-03-18T19:43:54.276427",
      "open": 3630.4057248575955,
      "high": 4131.2447714115315,
      "low": 3445.5394322707107,
      "close": 3940.966531661668,
      "volume": 9138.150616841993,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742308134276",
      "date": "2025-03-18T19:58:54.276427",
      "open": 3856.156960479933,
      "high": 4607.028657630335,
      "low": 3808.6390787233345,
      "close": 4376.336838581149,
      "volume": 1529.917052659134,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742309034276",
      "date": "2025-03-18T20:13:54.276427",
      "open": 4324.524456641089,
      "high": 4690.6824940236265,
      "low": 4178.7815546814745,
      "close": 4563.364392252026,
      "volume": 6687.295487370137,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742309934276",
      "date": "2025-03-18T20:28:54.276427",
      "open": 4668.916485998768,
      "high": 5055.680932114986,
      "low": 4458.319902037239,
      "close": 4904.307977440456,
      "volume": 7825.987676442733,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742310834276",
      "date": "2025-03-18T20:43:54.276427",
      "open": 4806.7261173121615,
      "high": 5269.539760569499,
      "low": 4768.714146644309,
      "close": 5135.489992433559,
      "volume": 3373.044456514387,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742311734276",
      "date": "2025-03-18T20:58:54.276427",
      "open": 5072.681245862423,
      "high": 5357.9478391288985,
      "low": 4992.906114740965,
      "close": 5355.936740384071,
      "volume": 5223.456542246822,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742312634276",
      "date": "2025-03-18T21:13:54.276427",
      "open": 5430.85768827557,
      "high": 5577.886034131191,
      "low": 5178.66786985671,
      "close": 5258.836897728501,
      "volume": 8553.935959615234,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742313534276",
      "date": "2025-03-18T21:28:54.276427",
      "open": 5327.121184932763,
      "high": 5551.263229699638,
      "low": 5170.822820509073,
      "close": 5181.1231525031035,
      "volume": 4095.965993924935,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742314434276",
      "date": "2025-03-18T21:43:54.276427",
      "open": 5132.32504250093,
      "high": 5733.552754049201,
      "low": 5009.842562426138,
      "close": 5576.3250332879625,
      "volume": 7674.218567914863,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742315334276",
      "date": "2025-03-18T21:58:54.276427",
      "open": 5496.152216046526,
      "high": 5544.1018187393465,
      "low": 5251.46565930702,
      "close": 5356.113936596263,
      "volume": 6240.671368173855,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742316234276",
      "date": "2025-03-18T22:13:54.276427",
      "open": 5343.109644693398,
      "high": 5625.066121881267,
      "low": 5337.606362934008,
      "close": 5623.809466882072,
      "volume": 1631.3201820087374,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742317134276",
      "date": "2025-03-18T22:28:54.276427",
      "open": 5620.7020958845615,
      "high": 5707.187685593348,
      "low": 5234.5642648405965,
      "close": 5460.595397681079,
      "volume": 9600.21712297814,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742318034276",
      "date": "2025-03-18T22:43:54.276427",
      "open": 5534.609765792943,
      "high": 5791.598748487199,
      "low": 5482.878372740803,
      "close": 5753.75905174989,
      "volume": 6663.037812964005,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742318934276",
      "date": "2025-03-18T22:58:54.276427",
      "open": 5670.42650999853,
      "high": 5871.900684301833,
      "low": 5232.434607758715,
      "close": 5438.286765780136,
      "volume": 5847.402853296198,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742319834276",
      "date": "2025-03-18T23:13:54.276427",
      "open": 5471.767643377504,
      "high": 5486.772887339213,
      "low": 5363.908987368096,
      "close": 5389.493398070336,
      "volume": 1011.500667739703,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742320734276",
      "date": "2025-03-18T23:28:54.276427",
      "open": 5387.578689881106,
      "high": 5429.435395627233,
      "low": 5045.869531423684,
      "close": 5161.855411279304,
      "volume": 2894.485484134111,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742321634276",
      "date": "2025-03-18T23:43:54.276427",
      "open": 5236.285035801522,
      "high": 5568.714683015519,
      "low": 5198.670655308303,
      "close": 5392.217125095727,
      "volume": 6698.235540149918,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742322534276",
      "date": "2025-03-18T23:58:54.276427",
      "open": 5457.294812614377,
      "high": 5637.9015641800315,
      "low": 5242.9398137370845,
      "close": 5259.889256876541,
      "volume": 4776.330068464305,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742323434276",
      "date": "2025-03-19T00:13:54.276427",
      "open": 5275.331385658561,
      "high": 5413.257445461323,
      "low": 4939.620990794048,
      "close": 4958.9961700463655,
      "volume": 4232.953397451418,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742324334276",
      "date": "2025-03-19T00:28:54.276427",
      "open": 4962.696812186544,
      "high": 5253.9532138378,
      "low": 4892.6260593018,
      "close": 5126.788930682412,
      "volume": 3525.811211236808,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742325234276",
      "date": "2025-03-19T00:43:54.276427",
      "open": 5058.349636210842,
      "high": 5451.527922843241,
      "low": 4842.570237587381,
      "close": 5329.696022672426,
      "volume": 4925.20016942841,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742326134276",
      "date": "2025-03-19T00:58:54.276427",
      "open": 5421.621794605653,
      "high": 5652.910629509766,
      "low": 5231.281818341588,
      "close": 5409.370289840201,
      "volume": 9689.28595875641,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742327034276",
      "date": "2025-03-19T01:13:54.276427",
      "open": 5327.456733377344,
      "high": 5516.7896424014125,
      "low": 5313.698826458821,
      "close": 5332.316890142794,
      "volume": 9419.21454867034,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742327934276",
      "date": "2025-03-19T01:28:54.276427",
      "open": 5350.054212716699,
      "high": 5717.859243310058,
      "low": 5121.82559374457,
      "close": 5630.339244887492,
      "volume": 6704.444376932169,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742328834276",
      "date": "2025-03-19T01:43:54.276427",
      "open": 5702.033501765818,
      "high": 5876.182527870439,
      "low": 5426.649965994707,
      "close": 5553.78804655668,
      "volume": 5304.62941813777,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742329734276",
      "date": "2025-03-19T01:58:54.276427",
      "open": 5541.329333546983,
      "high": 5644.779377639221,
      "low": 5432.322764542964,
      "close": 5531.342425948539,
      "volume": 7917.770354491147,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742330634276",
      "date": "2025-03-19T02:13:54.276427",
      "open": 5637.36113665637,
      "high": 5768.214453975804,
      "low": 5380.950846221289,
      "close": 5613.20961352205,
      "volume": 4432.777638801179,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742331534276",
      "date": "2025-03-19T02:28:54.276427",
      "open": 5507.343755940116,
      "high": 5672.983493129953,
      "low": 5500.82738621869,
      "close": 5510.621131632029,
      "volume": 7443.197973543082,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742332434276",
      "date": "2025-03-19T02:43:54.276427",
      "open": 5528.232262884756,
      "high": 5748.352498250469,
      "low": 5467.200485928126,
      "close": 5521.163636559822,
      "volume": 8364.883881454887,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742333334276",
      "date": "2025-03-19T02:58:54.276427",
      "open": 5491.387875014467,
      "high": 5966.349461448639,
      "low": 5482.487208217197,
      "close": 5856.259356268755,
      "volume": 1859.911357271746,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742334234276",
      "date": "2025-03-19T03:13:54.276427",
      "open": 5797.786304175255,
      "high": 6085.343712883877,
      "low": 5567.265714239242,
      "close": 6029.415627234726,
      "volume": 1497.1912292245129,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742335134276",
      "date": "2025-03-19T03:28:54.276427",
      "open": 5967.178582591609,
      "high": 6186.587285460423,
      "low": 5646.596227532206,
      "close": 5874.2705126977835,
      "volume": 7986.974430100118,
      "promptText": null,
      "state": "natural"
    },
    {
      "id": "candle-1742336034276",
      "date": "2025-03-19T03:43:54.276427",
      "open": 5909.041708394412,
      "high": 6047.980600211878,
      "low": 5745.556441889315,
      "close": 6013.447211217947,
      "volume": 1531.07378709058,
      "promptText": null,
      "state": "natural"
    }
  ],
  "chartSettings": {
    "dataFit": "adaptiveWidth",
    "yAxisSettings": {
      "axisTextStyle": {
        "color": "#ff000000",
        "fontSize": 12.0,
        "fontWeight": "w400"
      },
      "strokeWidth": 1.0,
      "axisColor": "#ff000000",
      "yAxisPos": "right"
    },
    "xAxisSettings": {
      "axisTextStyle": {
        "color": "#ff000000",
        "fontSize": 12.0,
        "fontWeight": "w400"
      },
      "strokeWidth": 1.0,
      "axisColor": "#ff000000",
      "xAxisPos": "bottom"
    },
    "mainPlotRegionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
  },
  "tasks": [
    {
      "id": "df8ad382-6878-41a3-961d-6be2f9c66693",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Let’s learn about support and resistance.",
      "isExplanation": false
    },
    {
      "id": "31702f24-0355-4f76-8328-40ec65aef39d",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "360edf8b-9e66-438e-b38d-0cbb8af26215",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Click on a button to load data",
      "isExplanation": false
    },
    {
      "id": "1e27f3e0-2b0a-42d1-a26a-46cd946ef1d2",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Let's Go"
    },
    {
      "id": "76166793-1c6b-45dc-9c75-710dc389aeef",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 0,
      "tillPoint": 18
    },
    {
      "id": "791c88a0-9057-47d8-976f-c0aa9a341abe",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Move the circle to candle from where price is moving in downward direction",
      "isExplanation": false
    },
    {
      "id": "224cce65-6357-44ed-8908-dd18b9106b79",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "024f5ede-ddab-4d63-b049-65c40f37b2c3",
        "type": "circularArea",
        "isLocked": false,
        "isSelectd": false,
        "point": {"dx": 6.0, "dy": 3974.8095379311735},
        "radius": 20.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "994ad626-504f-4cb7-a3a8-88d710a23693",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "68a18bc3-61d6-4a87-baad-0b357e421303",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "4d1c8199-51e6-45f0-a09a-d9f1f94fc8a2",
        "type": "circularArea",
        "isLocked": true,
        "isSelectd": false,
        "point": {"dx": 6.0, "dy": 4983.850820769795},
        "radius": 50.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "c0c714c5-e0a5-46e3-a193-ef72142581f9",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Green circle shows the correct answer!\nHope you got it right!!",
      "isExplanation": true
    },
    {
      "id": "d08cff00-0117-42e9-b909-c3d70670eb47",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "f8136bcb-8dcb-4363-a5e0-e65b76e00d72",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Can you find a point from which price is bouncing back?\nDrag the blue circle to that point",
      "isExplanation": false
    },
    {
      "id": "a64ae534-715e-4d8b-a738-c6799ecb7b93",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "8f3069d4-0e59-4e58-824a-9098a438ee63",
        "type": "circularArea",
        "isLocked": false,
        "isSelectd": false,
        "point": {"dx": 14.0, "dy": 4816.672383376414},
        "radius": 20.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "1c419024-9a50-4c20-b238-76d2fb0015aa",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "6d8e4410-cc52-473d-95a7-e23dd58d6e19",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "c89690e7-4392-4c84-b092-3c9d753f3d97",
        "type": "circularArea",
        "isLocked": true,
        "isSelectd": false,
        "point": {"dx": 14.0, "dy": 3817.5822283700236},
        "radius": 50.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "0b79cacd-d1d2-49f3-93ee-f21b321d396b",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Hope you got that also right!!\nLet’s add more data",
      "isExplanation": true
    },
    {
      "id": "e12be31f-684e-4753-8336-9f1c1381b721",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "cf4884ab-a7d9-4896-affe-8960e8f26293",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 18,
      "tillPoint": 42
    },
    {
      "id": "2282010a-e0e3-4583-b2a9-37eb41a96501",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "3b4a0197-5796-4479-9b55-82a2d1399ab3",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "When stock struggles to cross particulate price range it is called resistance.",
      "isExplanation": false
    },
    {
      "id": "b89ea36a-3547-4ca3-b11e-2d3c40182f5f",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Okay"
    },
    {
      "id": "f20b632c-f2dd-4358-a59d-62a7cad776dd",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Price from which stock bounces back is called support line",
      "isExplanation": false
    },
    {
      "id": "4509a266-ed5e-4705-8546-6c0d26ae969f",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Got it"
    },
    {
      "id": "4ba46e85-fd64-4d09-b9b2-d9208e65ae86",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText": "Let’s adjust support and resistance line in given chart",
      "isExplanation": false
    },
    {
      "id": "1009795e-396f-4986-b5df-17f40d43fde2",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "e075fcc5-f18a-4a0a-9509-57a16693a029",
        "type": "horizontalLine",
        "isLocked": false,
        "isSelectd": false,
        "value": 4450.471935968521,
        "color": "#ff4caf50",
        "strokeWidth": 2.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "b76cb373-af24-444b-8a07-fa7dcae9399d",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "b05d63ca-696f-497c-b146-8a7f771a2419",
        "type": "horizontalLine",
        "isLocked": false,
        "isSelectd": false,
        "value": 4281.303309450699,
        "color": "#fff44336",
        "strokeWidth": 2.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "d9a92873-8555-4e73-a56c-c36f74573578",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Done"
    },
    {
      "id": "5574f4f3-f0ff-4d64-91b4-dcc15c526ea1",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "d0429ec1-3a14-4341-af92-8b2f9254631e",
        "type": "horizontalBand",
        "isLocked": false,
        "isSelectd": false,
        "value": 5055.498722509816,
        "allowedError": 40.0,
        "color": "#fff44336"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "56cd07b2-43dc-48f9-abcf-beee3efbab05",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "247e5922-7544-40c4-af30-950edf340bee",
        "type": "horizontalBand",
        "isLocked": false,
        "isSelectd": false,
        "value": 3805.6409114133535,
        "allowedError": 40.0,
        "color": "#ff4caf50"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "730e2897-1f0f-426a-80aa-80c6c0881d24",
      "actionType": "empty",
      "taskType": "addPrompt",
      "promptText":
          "Your red line must in red region and green line must be in green region.",
      "isExplanation": true
    },
    {
      "id": "83554d63-fedb-4d32-9f1e-cd7168741b4a",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Got it"
    },
    {
      "id": "be575ebe-de85-4efc-a379-878c3c090136",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 42,
      "tillPoint": 76
    },
    {
      "id": "f77a465b-006c-4f8a-b4af-87f1a1535169",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "464db97b-f96b-4e8a-8693-f4301d949f79",
        "type": "label",
        "isLocked": false,
        "isSelectd": false,
        "pos": {"dx": 41.0, "dy": 5389.855597296578},
        "label": "Resistance",
        "textColor": "#fff44336",
        "fontSize": 27.0,
        "fontWeight": "w700"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "c71ad067-a887-4682-ab09-b13af72c9020",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "84ce3a46-c111-4a37-a996-f9bad1a25b5a",
        "type": "label",
        "isLocked": false,
        "isSelectd": false,
        "pos": {"dx": 60.0, "dy": 5801.831032301696},
        "label": "Support",
        "textColor": "#ff4caf50",
        "fontSize": 20.0,
        "fontWeight": "w400"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "09dc71c2-d9b5-4584-8bc6-8ff1db3542ea",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "0b2b5304-bee8-4aa5-a13c-b267c640762b",
        "type": "arrow",
        "isLocked": false,
        "isSelectd": false,
        "from": {"dx": 62.0, "dy": 5620.721088827206},
        "to": {"dx": 62.0, "dy": 3851.415899010576},
        "strokeWidth": 2.0,
        "arrowheadSize": 15.0,
        "endPointRadius": 5.0,
        "color": "#ff4caf50",
        "isArrowheadAtTo": true
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "772c56ca-6914-4e4c-85b5-fa6f7b242826",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "765108fb-4a7d-434b-96be-c48ac0a51e67",
      "actionType": "empty",
      "taskType": "addData",
      "fromPoint": 76,
      "tillPoint": 100
    },
    {
      "id": "8031aa1d-95cd-469a-b3fe-6de4234752ac",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Let's Go"
    },
    {
      "id": "cdc1e23f-bc80-4f97-9efd-c926640df3cb",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "91c886e7-13cd-4dc1-b0b4-e0818848af87",
        "type": "rectArea",
        "isLocked": false,
        "isSelectd": false,
        "topLeft": {"dx": 76.0, "dy": 5863.527806209484},
        "topRight": {"dx": 88.0, "dy": 5863.527806209484},
        "bottomLeft": {"dx": 76.0, "dy": 4745.024481636391},
        "bottomRight": {"dx": 88.0, "dy": 4745.024481636391},
        "color": "#ffffc107",
        "strokeWidth": 2.0,
        "alpha": 51,
        "endPointRadius": 5.0
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "10cb44d5-b8bf-4f95-a2ed-07c13ec2f6ac",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Next"
    },
    {
      "id": "2b39c538-6308-42d0-9911-7119e64fe135",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "b86e32c5-4d8c-4a10-be5c-c5c90388bfa8",
        "type": "trendLine",
        "isLocked": false,
        "isSelectd": false,
        "from": {"dx": 88.0, "dy": 4116.115152286776},
        "to": {"dx": 95.0, "dy": 5324.1783540348915},
        "strokeWidth": 2.0,
        "endPointRadius": 5.0,
        "color": "#ff000000"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "32c83c60-1285-4507-8d2e-573ae6f9ccb8",
      "actionType": "interupt",
      "taskType": "waitTask",
      "btnText": "Check"
    },
    {
      "id": "ef393c79-8e99-4a7b-baad-096529c97ff7",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "a109a882-7449-4ae4-9a79-1a8384fc7f50",
        "type": "parallelChannel",
        "isLocked": true,
        "isSelectd": false,
        "topLeft": {"dx": 88.80000000000001, "dy": 4727.1125973064145},
        "topRight": {"dx": 98.88333282470707, "dy": 5837.655074276744},
        "bottomLeft": {"dx": 88.80000000000001, "dy": 5497.327449906629},
        "bottomRight": {"dx": 98.88333282470707, "dy": 6607.869926876959},
        "strokeWidth": 2.0,
        "channelAlpha": 51,
        "endPointRadius": 5.0,
        "color": "#ff2196f3"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    },
    {
      "id": "65c881e7-76eb-49d1-8001-85fe4c65b059",
      "actionType": "empty",
      "taskType": "addLayer",
      "layer": {
        "id": "b6c76962-2c41-492a-8af1-307ed45d6dd4",
        "type": "label",
        "isLocked": false,
        "isSelectd": false,
        "pos": {"dx": 93.0, "dy": 3419.538299446015},
        "label": "DONE!!!!",
        "textColor": "#ff009688",
        "fontSize": 32.0,
        "fontWeight": "w400"
      },
      "regionId": "609a7b6d-8dd9-43e9-ae40-0053d4c9cfba"
    }
  ]
};
