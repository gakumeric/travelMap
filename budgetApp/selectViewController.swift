//
//  selectViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/06.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import TextFieldEffects
import RealmSwift
import Cosmos

class selectViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate, UITextFieldDelegate {

    //ディスプレイサイズ取得
    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    let rect = UIScreen.main.bounds
    
    let q1Label = UILabel()
    let titleMemo = UILabel()
    let q2Label = UITextView()
    let titleCountry = UILabel()
    let countryField = UITextField()
    let titlePropose = UILabel()
    var proposeField = UITextField()
    let datalabelLabel = UILabel()
    let titleMoney = UILabel()
    let moneyField = UITextField()
    var exchangeTextfiled = UITextField()
    let titleDays = UILabel()
    var daysTextfield = UITextField()
    let scrollView = UIScrollView()
    var saveBtn = UIButton()
    
    var dataObject: String = ""
    
    var pickDictionary: [NSDictionary] = []
    var pickOption: [String] = []
    var pickpurpose: [String] = []
    var pickExch:[String] = []
    var pickDays:[String] = []
    
    private var myconPicker: UIPickerView!
    private var myPicker: UIPickerView!
    private var exchangePicker: UIPickerView!
    
    let titleTodo = UILabel()
    @IBOutlet weak var AkiraTextField1: AkiraTextField!
    @IBOutlet weak var AkiraTextField2: AkiraTextField!
    @IBOutlet weak var AkiraTextField3: AkiraTextField!
    
    let titleBuy = UILabel()
    @IBOutlet weak var AkiraTextField7: AkiraTextField!
    @IBOutlet weak var AkiraTextField8: AkiraTextField!
    @IBOutlet weak var AkiraTextField9: AkiraTextField!
    @IBOutlet weak var comView: CosmosView!
    
    var dataLating:Int! = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //showMapdata()
        
        // スクロールビューを生成
        //let scrollView = UIScrollView()
        scrollView.backgroundColor = #colorLiteral(red: 1, green: 0.9892826473, blue: 0.9302949743, alpha: 1)
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSize(width: rect.width, height: 1500)
        scrollView.bounces = false
        //scrollView.frame.size = CGSize(width: rect.width, height: rect.height)
        //scrollView.center = self.view.center
        //scrollView.indicatorStyle = .default // .white
        //scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        scrollView.delegate = self
        
        self.view.addSubview(scrollView)
        
        ///カウント
        datalabelLabel.frame = CGRect(x: 15, y: 40, width: 30, height: 40)
        datalabelLabel.textColor = UIColor.black
        datalabelLabel.textAlignment = .center
        datalabelLabel.font = UIFont.systemFont(ofSize: 16)
        datalabelLabel.layer.borderWidth = 1.0
        datalabelLabel.layer.cornerRadius = 15.0
        //datalabelLabel.backgroundColor = .black
        scrollView.addSubview(datalabelLabel)
        
        //タイトル
        q1Label.text = "Setting Data"    
        q1Label.frame = CGRect(x: 65, y: 40, width: d2w-100, height: 40)
        q1Label.textColor = UIColor.white
        q1Label.textAlignment = .center
        q1Label.font = UIFont(name: "Bodoni 72 Oldstyle",size: 26.0)
        q1Label.layer.borderWidth = 1.0
        q1Label.layer.cornerRadius = 5.0
        q1Label.backgroundColor = .blue
        scrollView.addSubview(q1Label)
        
        
        titleCountry.text = "Choose country :"
        titleCountry.frame = CGRect(x: 20, y: 120, width: 200, height: 30)
        titleCountry.textColor = UIColor.black
        titleCountry.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleCountry)
        //国選択
        countryField.text = ""
        countryField.placeholder = "What's country"
        countryField.frame = CGRect(x: 20, y: 150, width: d2w-40, height: 55)
        countryField.textColor = UIColor.black
        countryField.textAlignment = .center
        countryField.inputView = makeconPicker()
        countryField.font = UIFont.systemFont(ofSize: 25)
        countryField.backgroundColor = .white
        countryField.layer.borderWidth = 1.0
        countryField.layer.cornerRadius = 10.0
        scrollView.addSubview(countryField)
        
        titlePropose.text = "Choose propose :"
        titlePropose.frame = CGRect(x: 20, y: 230, width: 200, height: 30)
        titlePropose.textColor = UIColor.black
        titlePropose.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titlePropose)
        //目的
        proposeField.placeholder = "What's propose"
        proposeField.frame = CGRect(x: 20, y: 260, width: d2w-40, height: 50)
        proposeField.textColor = UIColor.black
        proposeField.textAlignment = .center
        proposeField.font = UIFont.systemFont(ofSize: 25)
        proposeField.inputView = makepurPicker()
        proposeField.backgroundColor = .white
        proposeField.layer.borderWidth = 1.0
        proposeField.layer.cornerRadius = 10.0
        scrollView.addSubview(proposeField)
        
        titleMoney.text = "Choose money :"
        titleMoney.frame = CGRect(x: 20, y: 330, width: 200, height: 30)
        titleMoney.textColor = UIColor.black
        titleMoney.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleMoney)
            //予算額picker
        //moneyField.text = "How much"
        moneyField.placeholder = "How much?"
        moneyField.frame = CGRect(x: 20, y: 360, width: d2w-40, height: 50)
        moneyField.textColor = UIColor.black
        moneyField.textAlignment = .center
        moneyField.font = UIFont.systemFont(ofSize: 25)
        moneyField.backgroundColor = .white
        moneyField.keyboardType = UIKeyboardType.numberPad
        moneyField.layer.borderWidth = 1.0
        moneyField.layer.cornerRadius = 10.0
        scrollView.addSubview(moneyField)
        
            exchangeTextfiled = UITextField(frame: CGRect(x: 0, y: 0, width:45, height: 50))
            exchangeTextfiled.layer.position = CGPoint(x: d2w-100, y: 25)
            exchangeTextfiled.delegate = self as? UITextFieldDelegate
            exchangeTextfiled.layer.cornerRadius = 5.0
            //exchangeTextfiled.layer.borderWidth = 1.5
            //exchangeTextfiled.layer.borderColor = UIColor.cyan.cgColor
            exchangeTextfiled.font = UIFont.systemFont(ofSize: CGFloat(20))
            exchangeTextfiled.textColor = UIColor.black
            exchangeTextfiled.backgroundColor = UIColor.white
            exchangeTextfiled.tintColor = UIColor.clear //キャレット(カーソル)を消す。
            exchangeTextfiled.inputView = makeexchnagePicker()  //ここでピッカービューをセットする。
            exchangeTextfiled.text = "円"
            exchangeTextfiled.textAlignment = .center
            moneyField.addSubview(exchangeTextfiled)
        
        titleTodo.text = "Choose todo :"
        titleTodo.frame = CGRect(x: 20, y: 430, width: 200, height: 30)
        titleTodo.textColor = UIColor.black
        titleTodo.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleTodo)
            //todoText: 1
        AkiraTextField1.text = "None"
        AkiraTextField1.textAlignment = .center
        AkiraTextField1.frame = CGRect(x: 20, y: 460, width: d2w-40, height: 50)
        AkiraTextField1.delegate = self
        AkiraTextField1.placeholderColor = .black
        AkiraTextField1.borderColor = .red
        scrollView.addSubview(AkiraTextField1)
        
            //todoText: 2
        AkiraTextField2.text = "None"
        AkiraTextField2.frame = CGRect(x: 20, y: 540, width: d2w-40, height: 50)
        AkiraTextField2.textAlignment = .center
        AkiraTextField2.delegate = self
        AkiraTextField2.placeholderColor = .black
        AkiraTextField2.borderColor = .red
        scrollView.addSubview(AkiraTextField2)
        
            //todoText: 3
        AkiraTextField3.text = "None"
        AkiraTextField3.frame = CGRect(x: 20, y: 620, width: d2w-40, height: 50)
        AkiraTextField3.textAlignment = .center
        AkiraTextField3.delegate = self
        AkiraTextField3.placeholderColor = .black
        AkiraTextField3.borderColor = .red
        scrollView.addSubview(AkiraTextField3)
        
        titleDays.text = "Choose days :"
        titleDays.frame = CGRect(x: 20, y: 690, width: 200, height: 30)
        titleDays.textColor = UIColor.black
        titleDays.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleDays)
            //滞在予定日数picker
        daysTextfield.placeholder = "How many days will you stay?"
        daysTextfield.frame = CGRect(x: 20, y: 720, width: d2w-40, height: 50)
        daysTextfield.textColor = UIColor.black
        daysTextfield.textAlignment = .center
        daysTextfield.font = UIFont.systemFont(ofSize: 25)
        daysTextfield.inputView = makeDaysPicker()
        daysTextfield.backgroundColor = .white
        daysTextfield.layer.borderWidth = 1.0
        daysTextfield.layer.cornerRadius = 10.0
        scrollView.addSubview(daysTextfield)
        
        
        titleBuy.text = "Choose buy :"
        titleBuy.frame = CGRect(x: 20, y: 790, width: 200, height: 30)
        titleBuy.textColor = UIColor.black
        titleBuy.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleBuy)
        //買うものtext
        AkiraTextField7.text = "None"
        AkiraTextField7.frame = CGRect(x: 20, y: 820, width: d2w-40, height: 50)
        AkiraTextField7.textAlignment = .center
        AkiraTextField7.delegate = self
        AkiraTextField7.placeholderColor = .black
        AkiraTextField7.borderColor = .blue
        scrollView.addSubview(AkiraTextField7)
        
        AkiraTextField8.text = "None"
        AkiraTextField8.frame = CGRect(x: 20, y: 900, width: d2w-40, height: 50)
        AkiraTextField8.textAlignment = .center
        AkiraTextField8.delegate = self
        AkiraTextField8.placeholderColor = .black
        AkiraTextField8.borderColor = .blue
        scrollView.addSubview(AkiraTextField8)

        AkiraTextField9.text = "None"
        AkiraTextField9.frame = CGRect(x: 20, y: 980, width: d2w-40, height: 50)
        AkiraTextField9.textAlignment = .center
        AkiraTextField9.delegate = self
        AkiraTextField9.placeholderColor = .black
        AkiraTextField9.borderColor = .blue
        scrollView.addSubview(AkiraTextField9)
        
        titleMemo.text = "memo :"
        titleMemo.frame = CGRect(x: 20, y: 1050, width: 200, height: 30)
        titleMemo.textColor = UIColor.black
        titleMemo.font = UIFont(name: "Bodoni 72 Oldstyle",size: 14.0)
        scrollView.addSubview(titleMemo)
        //特記メモtextview
        q2Label.text = "None"
        q2Label.frame = CGRect(x: 20, y: 1080, width: d2w-40, height: 180)
        q2Label.textColor = UIColor.black
        q2Label.textAlignment = .left
        q2Label.font = UIFont.systemFont(ofSize: 20)
        q2Label.backgroundColor = .white
        q2Label.layer.borderWidth = 1.0
        q2Label.layer.cornerRadius = 10.0
        scrollView.addSubview(q2Label)
        
        
        // キーボードに表示するツールバーの表示
        let pickerToolBar = UIToolbar(frame: CGRect(x:0, y:self.view.frame.size.height/6, width:self.view.frame.size.width, height:40.0))
        pickerToolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        pickerToolBar.barStyle = .blackTranslucent
        pickerToolBar.tintColor = UIColor.white
        pickerToolBar.backgroundColor = UIColor.clear
        
        //ボタンの設定
        //右寄せのためのスペース設定
        let spaceBarBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,target: self,action: nil)
        //完了ボタンを設定
        let toolBarBtn = UIBarButtonItem(title: "完了", style: .done, target: self, action: #selector(selectViewController.tappedBarBtn))
        //ツールバーにボタンを表示
        pickerToolBar.items = [spaceBarBtn,toolBarBtn]
        countryField.inputAccessoryView = pickerToolBar
        proposeField.inputAccessoryView = pickerToolBar
        exchangeTextfiled.inputAccessoryView = pickerToolBar
        daysTextfield.inputAccessoryView = pickerToolBar
        moneyField.inputAccessoryView = pickerToolBar
        AkiraTextField1.inputAccessoryView = pickerToolBar
        AkiraTextField2.inputAccessoryView = pickerToolBar
        AkiraTextField3.inputAccessoryView = pickerToolBar
        AkiraTextField7.inputAccessoryView = pickerToolBar
        AkiraTextField8.inputAccessoryView = pickerToolBar
        AkiraTextField9.inputAccessoryView = pickerToolBar
        q2Label.inputAccessoryView = pickerToolBar
        
        
        comView.frame = CGRect(x: 20, y: 1300, width: d2w-40, height: 50)
        scrollView.addSubview(comView)
        // タッチダウン時やドラッグしてレートが変わった場合に呼ばれる
        comView.didTouchCosmos = { rating in
            // ratingでレートの値（Double）が受け取れる
            print(rating)
        }
        // ビューから指を離した時に呼ばれる
        comView.didFinishTouchingCosmos = { rating in
            // ratingでレートの値（Double）が受け取れる
            print(rating)
            self.dataLating = Int(rating)
        }
        
        //「保存！」ボタン
        saveBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: 1400, width: 200, height: 40))
        saveBtn.setTitle("Save！", for: UIControl.State())
        saveBtn.setTitleColor(.white, for: UIControl.State())
        saveBtn.backgroundColor = .orange
        saveBtn.layer.cornerRadius = 10.0
        saveBtn.layer.borderColor = UIColor.orange.cgColor
        saveBtn.layer.borderWidth = 1.0
        saveBtn.addTarget(self, action: #selector(onsaveEvent(_:)), for: .touchUpInside)
        scrollView.addSubview(saveBtn)
        
        //「戻る!」ボタン
        let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: 1450, width: 200, height: 30))
        backBtn.setTitle("Back", for: UIControl.State())
        backBtn.setTitleColor(.orange, for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor.orange.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
        scrollView.addSubview(backBtn)
    }


    //DB書き込み処理
    @objc func onsaveEvent(_ : UIButton){
        //print(dataLating)
        print("データ書き込み開始")
        
        let realm = try! Realm()
        _ = realm.objects(Mapdata.self)
        
        if countryField.text! == "" || proposeField.text! == "" || moneyField.text! == "" || AkiraTextField1.text! == "" || AkiraTextField2.text! == "" || AkiraTextField3.text! == "" || daysTextfield.text! == "" || AkiraTextField7.text! == "" || AkiraTextField8.text! == "" || AkiraTextField9.text! == "" || q2Label.text == "" {
        
            let alert: UIAlertController = UIAlertController(title: "Alert", message: "すべて記入してください", preferredStyle:  UIAlertController.Style.alert)
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
            })
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
                
            print("error")
        } else {
            
            if q1Label.text == "Setting Data" {
                
                try! realm.write {
                    print("データ書き込み中")
                    
                    //日付表示の内容とスケジュール入力の内容が書き込まれる。
                    let Mapdatas = [Mapdata(value: ["id":Int(NSDate().timeIntervalSince1970),"number": datalabelLabel.text!,"name": countryField.text!,"purpose": proposeField.text!,"money": Int(moneyField.text!)!,"exchange": exchangeTextfiled.text!,"todoone": AkiraTextField1.text!,"todotwo": AkiraTextField2.text!,"todothree": AkiraTextField3.text!,"days": Int(daysTextfield.text!)!,"buyone": AkiraTextField7.text!,"buytwo": AkiraTextField8.text!,"buythree": AkiraTextField9.text!,"memotext": q2Label.text,"priority": dataLating])]
                    realm.add(Mapdatas, update: true)
                    print(Mapdatas)
                    print("データ書き込み完了")
                }
            } else {
                
                let plans = realm.objects(Mapdata.self)
                print(plans)
                for ev in plans {
                    if ev.number == datalabelLabel.text {
                        try! realm.write {
                            ev.name = countryField.text!
                            ev.purpose = proposeField.text!
                            ev.money = Int(moneyField.text!)!
                            ev.exchange = exchangeTextfiled.text!
                            ev.todoone = AkiraTextField1.text!
                            ev.todotwo = AkiraTextField2.text!
                            ev.todothree = AkiraTextField3.text!
                            ev.days = Int(daysTextfield.text!)!
                            ev.buyone = AkiraTextField7.text!
                            ev.buytwo = AkiraTextField8.text!
                            ev.buythree = AkiraTextField9.text!
                            ev.memotext = q2Label.text
                            ev.priority = Int(comView.rating)
                            print("データ書き換え中")
                        }
                        print("データ書き込み完了")
                    }
                }
            }
            print("データ書き込み完了")
            dismiss(animated: true, completion: nil)
        }
//        print("データ書き込み完了")
//        //前のページに戻る
//        dismiss(animated: true, completion: nil)
        
    }
    
    //画面遷移(カレンダーページ)
    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    //ピッカービューの作成
    func makeconPicker() -> UIPickerView
    {
        //配列の初期化
        for _ in 1..<100
        {
            pickOption +=
                ["☆None", "アイスランド", "アイルランド", "アゼルバイジャン", "アメリカ合衆国", "アラブ首長国連邦", "アフガニスタン", "アルジェリア", "アンティグア・バーブーダ", "アンドラ", "アルバニア", "アルメニア", "アンゴラ", "アルゼンチン", "イエメン", "イタリア", "イギリス", "インドネシア", "イスラエル", "インド", "イラク", "イラン", "ウクライナ", "ウガンダ", "ウルグアイ", "ウズベキスタン", "エクアドル", "エストリア", "エジプト", "エリトリア", "エルサルバドル", "エチオピア", "オーストリア", "オーストラリア", "オマーン", "オランダ", "カーボヴェルデ", "カザフスタン", "カタール", "ガボン", "カナダ", "カメルーン", "ガーナ", "ガンビア", "カンボジア", "ガイアナ", "キューバ", "ギニアビサウ", "キリバス", "キプロス", "ギニア", "ギリシャ", "キルギス", "グアテマラ", "クウェート", "クック諸島", "クロアチア", "グレナダ", "ケニア", "コソボ", "コートジボワール", "コモロ", "コロンビア", "コスタリカ", "コンゴ民主共和国", "コンゴ共和国", "サウジアラビア", "サントメ・プリンシペ", "サンマリノ", "サモア", "ザンビア", "ジンバブエ", "シエラレオネ", "ジブチ", "ジョージア", "ジャマイカ", "シリア", "シンガポール", "スイス", "スリナム", "スワジランド", "スーダン", "スウェーデン", "スロベニア", "スロバキア", "スペイン", "スリランカ", "セルビア", "セーシェル", "セントキッツ", "セントルシア", "セネガル", "セントビンセント・グレナディーン", "ソマリア", "ソロモン諸島", "タイ", "タジキスタン", "タンザニア", "チュニジア", "チリ", "チャド", "チェコ", "ツバル", "デンマーク", "ドイツ", "ドミニカ国", "トーゴ", "トルクメニスタン", "トンガ", "トルコ", "トリニダード・トバゴ", "ドミニカ共和国", "ナミビア", "ナイジェリア", "ナウル", "ニウエ", "ニジェール", "ニュージーランド", "ニカラグア", "ネパール", "ノルウェー", "ハイチ", "ハンガリー", "バルバドス", "バングラデシュ", "パキスタン", "バヌアツ", "パナマ", "パラオ", "パラグアイ", "バチカン市国", "バハマ", "パプアニューギニア", "バーレーン", "フィンランド", "ブルガリア", "ブルネイ", "ブラジル", "ブータン", "ブルンジ", "フィリピン", "フィジー", "フランス", "ブルキナファソ", "ペルー", "ベナン", "ベルギー", "ベリーズ", "ベネズエラ", "ベラルーシ", "ベトナム", "ボリビア", "ホンジュラス", "ボツワナ", "ポーランド", "ポルトガル", "ボスニア・ヘルツェゴビナ", "マダガスカル", "マーシャル諸島", "マケドニア", "マラウイ", "マリ", "マレーシア", "マルタ", "ミクロネシア", "ミャンマー", "メキシコ", "モンゴル", "モーリタニア", "モーリシャス", "モルディブ", "モロッコ", "モナコ", "モルドバ", "モンテネグロ", "モザンビーク", "ラオス", "ラトビア", "リトアニア", "ルクセンブルク", "ルーマニア", "ヨルダン", "リベリア", "リヒテンシュタイン", "リビア", "ルワンダ", "レソト", "レバノン", "ロシア", "赤道ギニア", "中央アフリカ", "東ティモール", "中国", "台湾", "南アフリカ", "南スーダン", "北朝鮮", "韓国", "日本"]
        }
        myconPicker = UIPickerView()
        myconPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200.0)
        myconPicker.layer.position = CGPoint(x:0, y:0)
        myconPicker.backgroundColor = UIColor.clear
        myconPicker.tag = 1
        myconPicker.delegate = self
        myconPicker.dataSource = self
        myconPicker.showsSelectionIndicator = true

        //初期選択位置の設定
        myconPicker.selectRow(24*50, inComponent: 0, animated: true)
        return myconPicker
        
    }
    
    func makepurPicker() -> UIPickerView
    {
        //配列の初期化
        for _ in 1..<100
        {
            pickpurpose += ["☆None", "Trip", "Study", "Volunteer", "work", "Friend", "feeling"]
        }
        myPicker = UIPickerView()
        myPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200.0)
        myPicker.layer.position = CGPoint(x:0, y:0)
        myPicker.backgroundColor = UIColor.clear
        myPicker.tag = 2
        myPicker.delegate = self
        myPicker.dataSource = self
        //初期選択位置の設定
        myPicker.selectRow(24*50, inComponent: 0, animated: true)
        return myPicker
    }
    
    func makeexchnagePicker() -> UIPickerView
    {
        //配列の初期化
        for _ in 1..<100
        {
            pickExch += ["円"]// ["円", "ドル", "ペソ", "リラ", "ウォン"]
        }
        exchangePicker = UIPickerView()
        exchangePicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200.0)
        exchangePicker.layer.position = CGPoint(x:0, y:0)
        exchangePicker.backgroundColor = UIColor.clear
        exchangePicker.tag = 3
        exchangePicker.delegate = self
        exchangePicker.dataSource = self
        //初期選択位置の設定
        exchangePicker.selectRow(24*50, inComponent: 0, animated: true)
        return exchangePicker
    }
    
    func makeDaysPicker() -> UIPickerView
    {
        //配列の初期化
        for _ in 1..<100
        {
            pickDays += ["0", "1", "2", "3", "4", "5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21"]
        }
        myPicker = UIPickerView()
        myPicker.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 200.0)
        myPicker.layer.position = CGPoint(x:0, y:0)
        myPicker.backgroundColor = UIColor.clear
        myPicker.tag = 4
        myPicker.delegate = self
        myPicker.dataSource = self
        //初期選択位置の設定
        myPicker.selectRow(0, inComponent: 0, animated: true)
        return myPicker
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffsetY = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        _ = maximumOffset - currentOffsetY
        //print("currentOffsetY: \(currentOffsetY)")
        //print("maximumOffset: \(maximumOffset)")
        //print("distanceToBottom: \(distanceToBottom)")
        
        //        if distanceToBottom < 500 {
        //            viewModel.fetchArticles()
        //        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.datalabelLabel.text = dataObject
        
        //すべて取得
        let realm = try! Realm()
        let result = realm.objects(Mapdata.self)
        //print(result)
        
        for ev in result {
            if ev.number == datalabelLabel.text {
                q1Label.text = "Fixing Data"
                q1Label.backgroundColor = .red
                countryField.text = ev.name
                proposeField.text = ev.purpose
                moneyField.text = String(ev.money)
                exchangeTextfiled.text = ev.exchange
                AkiraTextField1.text = ev.todoone
                AkiraTextField2.text = ev.todotwo
                AkiraTextField3.text = ev.todothree
                daysTextfield.text = String(ev.days)
                AkiraTextField7.text = ev.buyone
                AkiraTextField8.text = ev.buytwo
                AkiraTextField9.text = ev.buythree
                q2Label.text = ev.memotext
                comView.rating = Double(ev.priority)
                saveBtn.setTitle("Edit！", for: UIControl.State())
            }
        }
        
        
        self.datalabelLabel.text = dataObject
        
        //let notificationCenter = NotificationCenter.default
        //notificationCenter.addObserver(self, selector: #selector(selectViewController.handleKeyboardWillShowNotification), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //notificationCenter.addObserver(self, selector: #selector(selectViewController.handleKeyboardWillHideNotification), name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TextFieldの選択範囲を最初から最後まで(全選択)に指定する
        AkiraTextField1.selectedTextRange = AkiraTextField1.textRange(
            from: AkiraTextField1.beginningOfDocument,
            to: AkiraTextField1.endOfDocument)
        AkiraTextField2.selectedTextRange = AkiraTextField2.textRange(
            from: AkiraTextField2.beginningOfDocument,
            to: AkiraTextField2.endOfDocument)
        AkiraTextField3.selectedTextRange = AkiraTextField3.textRange(
            from: AkiraTextField3.beginningOfDocument,
            to: AkiraTextField3.endOfDocument)
        AkiraTextField7.selectedTextRange = AkiraTextField7.textRange(
            from: AkiraTextField7.beginningOfDocument,
            to: AkiraTextField7.endOfDocument)
        AkiraTextField8.selectedTextRange = AkiraTextField8.textRange(
            from: AkiraTextField8.beginningOfDocument,
            to: AkiraTextField8.endOfDocument)
        AkiraTextField9.selectedTextRange = AkiraTextField9.textRange(
            from: AkiraTextField9.beginningOfDocument,
            to: AkiraTextField9.endOfDocument)
        q2Label.selectedTextRange = q2Label.textRange(
            from: q2Label.beginningOfDocument,
            to: q2Label.endOfDocument)
    }
    

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return pickOption.count
        } else if pickerView.tag == 2 {
            return pickpurpose.count
        } else if pickerView.tag == 3 {
            return pickExch.count
        } else {
            return pickDays.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
                return pickOption[row]
        } else if pickerView.tag == 2 {
                return pickpurpose[row]
        } else if pickerView.tag == 3 {
            return pickExch[row]
        } else {
            return pickDays[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("row: \(row) , value: \(pickOption[row])")
        if pickerView.tag == 1 {
        //テキストビューの値変更
            countryField.text = "\(pickOption[row])"
        } else if pickerView.tag == 2 {
            proposeField.text = "\(pickpurpose[row])"
        } else if pickerView.tag == 3 {
            exchangeTextfiled.text = "\(pickExch[row])"
        } else {
            //daysTextfield.text = "\(pickDays[row])days"
            daysTextfield.text = "\(pickDays[row])"
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    //完了を押すとピッカーの値を、テキストフィールドに挿入して、ピッカーを閉じる
    @objc func tappedBarBtn(sender: UIBarButtonItem) {
        countryField.endEditing(true)
        proposeField.endEditing(true)
        exchangeTextfiled.endEditing(true)
        daysTextfield.endEditing(true)
        moneyField.endEditing(true)
        AkiraTextField1.endEditing(true)
        AkiraTextField2.endEditing(true)
        AkiraTextField3.endEditing(true)
        AkiraTextField7.endEditing(true)
        AkiraTextField8.endEditing(true)
        AkiraTextField9.endEditing(true)
        q2Label.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //次の入力欄に移動する
        if AkiraTextField1.resignFirstResponder() {
            let nextTag = AkiraTextField1.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        } else if AkiraTextField2.resignFirstResponder() {
            let nextTag = AkiraTextField2.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        } else if AkiraTextField3.resignFirstResponder() {
            let nextTag = AkiraTextField3.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        } else if AkiraTextField7.resignFirstResponder() {
            let nextTag = AkiraTextField7.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        } else if AkiraTextField8.resignFirstResponder() {
            let nextTag = AkiraTextField8.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        } else if AkiraTextField9.resignFirstResponder() {
            let nextTag = AkiraTextField9.tag + 1
            if let nextTextField = self.view.viewWithTag(nextTag) {
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    
//    @objc func handleKeyboardWillShowNotification(notification: NSNotification) {
//
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let myBoundSize: CGSize = UIScreen.main.bounds.size
//
//        let txtLimit = AkiraTextField1.frame.origin.y + AkiraTextField1.frame.height + 8.0
//        let kbdLimit = myBoundSize.height - keyboardScreenEndFrame.size.height
//
//        if txtLimit >= kbdLimit {
//            scrollView.contentOffset.y = txtLimit - kbdLimit
//        }
//    }

    @objc func handleKeyboardWillHideNotification(notification: NSNotification) {
        if AkiraTextField1.resignFirstResponder() {
            scrollView.contentOffset.y = 300
        } else if AkiraTextField2.resignFirstResponder() {
            scrollView.contentOffset.y = 400
        } else if AkiraTextField3.resignFirstResponder() {
            scrollView.contentOffset.y = 500
        } else if AkiraTextField7.resignFirstResponder() {
            scrollView.contentOffset.y = 700
        } else if AkiraTextField8.resignFirstResponder() {
            scrollView.contentOffset.y = 800
        } else if AkiraTextField9.resignFirstResponder() {
            scrollView.contentOffset.y = 900
        } else if q2Label.resignFirstResponder() {
            scrollView.contentOffset.y = 900
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        //let notificationCenter = NotificationCenter.default
        //notificationCenter.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillShowNotification, object: nil)
        //notificationCenter.removeObserver(self, name: NSNotification.Name.UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}
