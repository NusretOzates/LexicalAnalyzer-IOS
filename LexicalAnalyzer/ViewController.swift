//
//  ViewController.swift
//  LexicalAnalyzer
//
//  Created by Nusret Özateş on 12.05.2018.
//  Copyright © 2018 Nusret Özateş. All rights reserved.
//

import UIKit
import Speech
import Foundation
import Charts

extension String
{
    func hashtags(pattern : String) -> String
    {
        var pat = pattern
        var string = self as NSString
        if let regex = try? NSRegularExpression(pattern: pat, options: .caseInsensitive)
        {
            var math = regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length))
            for mat in math{
                string = string.replacingOccurrences(of: ".", with: " . ", range: mat.range) as NSString
            }
            return string as String
        }
        
        return "nope"
    }
    func contains(word : String) -> Bool
    {
        return self.range(of: "\\b\(word)\\b", options: .regularExpression) != nil
    }
}

class ViewController: UIViewController,UITextViewDelegate,SFSpeechRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ChartViewDelegate {
   
    let pickerdata = ["Phrasal Verbs -Bitti-","New-GSL","General Service List","Academic Word List-Bitti-","Academic Vocabulary List-Bitti-"
    ,"Academic Collocation List","Discourse Connectors-Bitti-"]
    var wordswithoutroot = [Word]()
    var sublist1 = BinarySearchTree()
    var sublist2 = BinarySearchTree()
    var sublist3 = BinarySearchTree()
    var sublist4 = BinarySearchTree()
    var sublist5 = BinarySearchTree()
    var sublist6 = BinarySearchTree()
    var sublist7 = BinarySearchTree()
    var sublist8 = BinarySearchTree()
    var sublist9 = BinarySearchTree()
    var sublist10 = BinarySearchTree()
  
    var dict1 : [String:[String]] = [:]
    var dict2 : [String:[String]] = [:]
    var dict3 : [String:[String]] = [:]
    var dict4 : [String:[String]] = [:]
    var dict5 : [String:[String]] = [:]
    var dict6 : [String:[String]] = [:]
    var dict7 : [String:[String]] = [:]
    var dict8 : [String:[String]] = [:]
    var dict9 : [String:[String]] = [:]
    var dict10 : [String:[String]] = [:]
    

    @IBOutlet weak var recordVoice: UIButton!
  
    @IBOutlet weak var analyzeButton: UIButton!
   
    @IBOutlet weak var choices: UIPickerView!
    @IBOutlet weak var textForAnalyze: UITextView!
    
    
  
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var listening = false
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?


    override func viewDidLoad()  {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        textForAnalyze.delegate = self
        speechRecognizer?.delegate = self
        textForAnalyze.clipsToBounds = true
        choices.delegate = self
        choices.dataSource = self
        textForAnalyze.layer.cornerRadius = 20
        recordVoice.layer.cornerRadius = 20
        analyzeButton.layer.cornerRadius = 20

    }

    
    func readDocumentFile(filename:String,binarySearchTree : BinarySearchTree )
    {
       //Verilen filename e sahip olan csv dosyasını alıp içindeki tüm verileri text e attık
        let bundle = Bundle.main
        let path = bundle.path(forResource: filename, ofType: "csv")
        let text = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
      
        // Tüm CSV Dosyasını satırlara ayırdık
        let lines = text?.split(separator: "\r\n")
      
        //  var dict = [String:[String]]()
        for line in lines!
        {
        //Virgüllere göre ayırdık.
            var fullNameArr = line.split(separator: ";")
        
       if(filename == "first500" || filename == "first5001000" || filename == "first10002500")
       {
           binarySearchTree.insert(p_word: Word(word: String(fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()))
       }else
       {
           // fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines) sondaki boşlukları siliyor.
           binarySearchTree.insert(p_word: Word(word : String(fullNameArr[1].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased(), root : String(fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()))
       }

        }
    }
    func readDocumentFile(filename: String, Arr: inout Array<Word>)
    {
        //Verilen filename e sahip olan csv dosyasını alıp içindeki tüm verileri text e attık
        let bundle = Bundle.main
        let path = bundle.path(forResource: filename, ofType: "csv")
        let text = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        
        // Tüm CSV Dosyasını satırlara ayırdık
        let lines = text?.split(separator: "\r\n")
        
        //  var dict = [String:[String]]()
        for line in lines!
        {
            //Virgüllere göre ayırdık.
            var fullNameArr = line.split(separator: ";")
            
            // fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines) sondaki boşlukları siliyor.
          if(filename == "academiccollocation" || filename == "discourseconnnector")
          {
              Arr.append(Word(word: String(fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()))

          }else
          {
              Arr.append(Word(word: String(fullNameArr[1].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased(),
                      root: String(fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()))
          }

        }
    }

    func readNGSLFile(filename:String,binarySearchTree : BinarySearchTree )
    {
        //Verilen filename e sahip olan csv dosyasını alıp içindeki tüm verileri text e attık
        let bundle = Bundle.main
        let path = bundle.path(forResource: filename, ofType: "csv")
        let text = try? String(contentsOfFile: path!, encoding: String.Encoding.utf8)

        // Tüm CSV Dosyasını satırlara ayırdık
        let lines = text?.split(separator: "\r\n")

        //  var dict = [String:[String]]()
        for line in lines!
        {
            //Virgüllere göre ayırdık.
            var fullNameArr = line.split(separator: ";")
            for word in fullNameArr
            {
                binarySearchTree.insert(p_word: Word(word : String(word.trimmingCharacters(in: .whitespacesAndNewlines)).lowercased(), root : String(fullNameArr[0].trimmingCharacters(in: .whitespacesAndNewlines)).lowercased()))
            }

        }
    }

  
    @IBAction func AnalyzeButtonClicked(_ sender: UIButton) {
        switch choices.selectedRow(inComponent: 0).description
        {
        case "0":
            self.readDocumentFile(filename: "frequentphrasalverbs", Arr: &wordswithoutroot)
            self.analyzePhrasalVerbs()

        case "2":
            self.readNGSLFile(filename: "first1000ngsl", binarySearchTree: self.sublist1)
            self.readNGSLFile(filename: "ngssecond1000", binarySearchTree: self.sublist1)
            self.readNGSLFile(filename: "ngslthird1000", binarySearchTree: self.sublist1)
            self.readNGSLFile(filename: "ngslsupplamental", binarySearchTree: self.sublist1)
            self.analyzeNGSL()

        case "1":
            self.readDocumentFile(filename: "first500", binarySearchTree: self.sublist1)
            self.readDocumentFile(filename: "first5001000", binarySearchTree: self.sublist1)
            self.readDocumentFile(filename: "first10002500", binarySearchTree: self.sublist1)
            self.analyzeNewGSlList()

        case "3" :

                    self.readDocumentFile(filename: "awlsublist1", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist2", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist3", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist4", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist5", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist6", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist7", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist8", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist9", binarySearchTree: self.sublist1)
                    self.readDocumentFile(filename: "awlsublist10",binarySearchTree: self.sublist1)
                    self.analyzeAwtList()
                    // Şuan bulunan kelimeler ve kökleri hazır dict ler bulunan kelime ve kökleri , yedek uniquelist de kalan kelimeler

        case "4":
                    self.readDocumentFile(filename: "academicwords", binarySearchTree: sublist1)
                    self.analyzeAcademicList()

        case "5" :
                    self.readDocumentFile(filename: "academiccollocation", Arr: &wordswithoutroot)
                    self.analyzeCollocations(luckynum: 3)
        case "6":
                    self.readDocumentFile(filename: "discourseconnnector", Arr: &wordswithoutroot)
                    self.analyzeCollocations(luckynum: 4)
        default:
                    print("You shouldnt see this message")
        }

    }

    func analyzeNewGSlList()
    {
        //TextViewdeki tüm kelimeler Array halinde
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
         var textarr = text.hashtags(pattern:"\\b([A-Za-z]+\\. [A-Za-z]{2,})")
         textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+\\.[A-Za-z]{2,})")
        print(textarr)
        let textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count

        var uniquelist :Set<String> = []
        var yedekuniquelist :Set<String> = []

        //Burada 2 listeye de tüm eşsiz kelimeleri ekliyoruz. 2 tane olmasının sebebi foreach esnasında döndürdüğüm listeden eleman silemem
        for words in textinedittext
        {
            uniquelist.insert(String(words))
            yedekuniquelist.insert(String(words))
        }
        let numberOfUniqueWords = uniquelist.count

        for words in uniquelist {
            // inout kullanınca find foksiyonunda , başına & işareti koyman gerekir , aynı C mantığı
            if sublist1.find(p_word: String(words), dictionaryToAddIfFind: &dict1) {
                yedekuniquelist.remove(String(words))
            }
        }
        // Şuan bulunan kelimeler ve kökleri hazır dict ler bulunan kelime ve kökleri , yedek uniquelist de kalan kelimeler
        //AnalyzeViewControlleri çektik
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in yedekuniquelist
        {
            let words = Word(word: word)
        myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = 5
        //self.present(myANL, animated: true, completion: nil)
        show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()

    }

    func analyzeNGSL()
    {
        //TextViewdeki tüm kelimeler Array halinde
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
        var textarr = text.hashtags(pattern:"\\b([A-Za-z]+\\. [A-Za-z]{2,})")
        textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+\\.[A-Za-z]{2,})")
        print(textarr)
        let textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count

        var uniquelist :Set<String> = []
        var yedekuniquelist :Set<String> = []

        //Burada 2 listeye de tüm eşsiz kelimeleri ekliyoruz. 2 tane olmasının sebebi foreach esnasında döndürdüğüm listeden eleman silemem
        for words in textinedittext
        {
            uniquelist.insert(String(words))
            yedekuniquelist.insert(String(words))
        }
        let numberOfUniqueWords = uniquelist.count

        for words in uniquelist {
            // inout kullanınca find foksiyonunda , başına & işareti koyman gerekir , aynı C mantığı
            if sublist1.find(p_word: String(words), dictionaryToAddIfFind: &dict1) {
                yedekuniquelist.remove(String(words))
            }
        }
        // Şuan bulunan kelimeler ve kökleri hazır dict ler bulunan kelime ve kökleri , yedek uniquelist de kalan kelimeler
        //AnalyzeViewControlleri çektik
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in yedekuniquelist
        {
          let words = Word(word: word)
            myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = 6
        //self.present(myANL, animated: true, completion: nil)
        show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()
    }


    func analyzeCollocations(luckynum : Int)
    {
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
        var textarr = text.hashtags(pattern:"\\b([A-Za-z]+)\\. ([A-Za-z]{2,})")
        textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+)\\.([A-Za-z]{2,})")
        print(textarr)
        var textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count
        //Birbirinden farklı kelime sayısı
        var uniquelist :Set<String> = []

        for words in textinedittext
        {
            uniquelist.insert(String(words).lowercased())
        }

        let numberOfUniqueWords = uniquelist.count

        // Phrasal verbsteki tüm kelimeleri teker teker alıp text bunu içeriyor mu diye kontrol ettik!
        // Eğer içeriyorsa sözlüğe ekledik ve textten çıkardık.
        for words in wordswithoutroot
        {
            if textarr.contains(words.getWord().lowercased())
            {
                dict1[words.getRoot(), default:[]].append(words.getWord())
                textarr = textarr.lowercased().replacingOccurrences(of: "\\b\(words.getWord())\\b", with: "", options: .regularExpression, range: (textarr.startIndex..<textarr.endIndex))
            }

        }
        //Uniqelistte kalan kelimeler
        textinedittext = textarr.split(separator: " ")

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in textinedittext
        {
            var words = Word(word: String(word))
            myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = luckynum
        //self.present(myANL, animated: true, completion: nil)
        show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()
    }
    func analyzeAcademicList()
    {
        //TextViewdeki tüm kelimeler Array halinde
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
        var textarr = text.hashtags(pattern:"\\b([A-Za-z]+\\. [A-Za-z]{2,})")
        textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+\\.[A-Za-z]{2,})")
        print(textarr)
        let textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count

        var uniquelist :Set<String> = []
        var yedekuniquelist :Set<String> = []

        //Burada 2 listeye de tüm eşsiz kelimeleri ekliyoruz. 2 tane olmasının sebebi foreach esnasında döndürdüğüm listeden eleman silemem
        for words in textinedittext
        {
            uniquelist.insert(String(words))
            yedekuniquelist.insert(String(words))
        }
        let numberOfUniqueWords = uniquelist.count
        for words in uniquelist {
            // inout kullanınca find foksiyonunda , başına & işareti koyman gerekir , aynı C mantığı
            if sublist1.find(p_word: String(words), dictionaryToAddIfFind: &dict1) {
                yedekuniquelist.remove(String(words))
            }
        }
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in yedekuniquelist
        {
            var words = Word(word: word)
            myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = 2
        //self.present(myANL, animated: true, completion: nil)
        show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()
    }
    func analyzePhrasalVerbs()
    {
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
        var textarr = text.hashtags(pattern:"\\b([A-Za-z]+)\\. ([A-Za-z]{2,})")
        textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+)\\.([A-Za-z]{2,})")
        print(textarr)
        var textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count
        var uniquelist :Set<String> = []
       
        for words in textinedittext
        {
            uniquelist.insert(String(words).lowercased())
        }
        
        let numberOfUniqueWords = uniquelist.count
        
        // Phrasal verbsteki tüm kelimeleri teker teker alıp text bunu içeriyor mu diye kontrol ettik!
        // Eğer içeriyorsa sözlüğe ekledik ve textten çıkardık.
        for words in wordswithoutroot
        {
            if textarr.lowercased().contains(words.getWord().lowercased())
            {
                dict1[words.getRoot(), default:[]].append(words.getWord().lowercased())
                textarr = textarr.lowercased().replacingOccurrences(of: "\(words.getWord().lowercased())", with: "", options: .regularExpression, range: (textarr.startIndex..<textarr.endIndex))
            }

        }
        //Uniqelistte kalan kelimeler
        textinedittext = textarr.split(separator: " ")
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in textinedittext
        {
            var words = Word(word: String(word))
            myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = 1
        //self.present(myANL, animated: true, completion: nil)
        show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()
    }
    
    // An thing
    func analyzeAwtList()
    {
        //TextViewdeki tüm kelimeler Array halinde
        var text = textForAnalyze.text.replacingOccurrences(of: "\n", with: "").lowercased()
        text = text.replacingOccurrences(of: ",", with: "")
        text = text.replacingOccurrences(of: ";", with: "")
        text = text.replacingOccurrences(of: "(", with: "")
        text = text.replacingOccurrences(of: ")", with: "")
        text = text.replacingOccurrences(of: "\"", with: "")
        print(text)
        print("###################")
        var textarr = text.hashtags(pattern:"\\b([A-Za-z]+\\. [A-Za-z]{2,})")
        textarr = textarr.hashtags(pattern: "\\b([A-Za-z]+\\.[A-Za-z]{2,})")
        print(textarr)
        let textinedittext = textarr.split(separator: " ")
        let numberOfWords  = textinedittext.count
        
        var uniquelist :Set<String> = []
        var yedekuniquelist :Set<String> = []
        
        //Burada 2 listeye de tüm eşsiz kelimeleri ekliyoruz. 2 tane olmasının sebebi foreach esnasında döndürdüğüm listeden eleman silemem
        for words in textinedittext
        {
            uniquelist.insert(String(words))
            yedekuniquelist.insert(String(words))
        }
        let numberOfUniqueWords = uniquelist.count
        for words in uniquelist
        {
            // inout kullanınca find foksiyonunda , başına & işareti koyman gerekir , aynı C mantığı
            if  sublist1.find(p_word: String(words),dictionaryToAddIfFind: &dict1)
            {
                yedekuniquelist.remove(String(words))
            }
        }
        // Şuan bulunan kelimeler ve kökleri hazır dict ler bulunan kelime ve kökleri , yedek uniquelist de kalan kelimeler
       //AnalyzeViewControlleri çektik
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let myANL = storyboard.instantiateViewController(withIdentifier: "AnalyzeView") as! AnalyzeViewController
        myANL.dict1 = dict1
        myANL.numberofwords = numberOfWords
        myANL.numberofuniquewords = numberOfUniqueWords
        for word in yedekuniquelist
        {
            let words = Word(word: word)
            myANL.leftwords![words.getRoot(), default:[]].append(words.getWord())
        }
        myANL.luckynumber = 0
        //self.present(myANL, animated: true, completion: nil)
       show(myANL, sender: self)
        dict1  = [:]
        dict2  = [:]
        dict3  = [:]
        dict4  = [:]
        dict5  = [:]
        dict6  = [:]
        dict7  = [:]
        dict8  = [:]
        dict9  = [:]
        dict10 = [:]
        sublist1 = BinarySearchTree()
        sublist2 = BinarySearchTree()
        sublist3 = BinarySearchTree()
        sublist4 = BinarySearchTree()
        sublist5 = BinarySearchTree()
        sublist6 = BinarySearchTree()
        sublist7 = BinarySearchTree()
        sublist8 = BinarySearchTree()
        sublist9 = BinarySearchTree()
        sublist10 = BinarySearchTree()
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerdata.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerdata[row]
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textForAnalyze.text = " "
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }

    @IBAction func refreshButton(_ sender: UIButton) {
        textForAnalyze.text = " "
    }
    
    @IBAction func startVoiceRecording(_ sender: UIButton) {
        askMicPermission(completion: { (granted, message) in
            DispatchQueue.main.async {
                if self.listening {
                    self.listening = false
                    
                    if granted {
                        self.stopListening()
                    }
                } else {
                    self.listening = true
                    self.recordVoice.setTitle("Recording", for: .normal)
                    if granted {
                        self.startListening()
                    }
                }
            }
        })
    }
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        recordVoice.isEnabled = available
        if available {
            listening = true
            recordVoice.setTitle("Tap to Record", for: .normal)
            startVoiceRecording(recordVoice)
        } else {
            textForAnalyze.text = "Recognition is not available."
        }
    }
    
    private func startListening() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryRecord)
            try audioSession.setMode(AVAudioSessionModeMeasurement)
            try audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        } catch let error {
            textForAnalyze.text = "An error occurred when starting audio session. \(error.localizedDescription)"
            return
        }
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.textForAnalyze.text = result?.bestTranscription.formattedString
                isFinal = result!.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                self.recordVoice.setTitle("Tap to Record", for: .normal)
            }
            
        })
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch let error {
            textForAnalyze.text = "An error occurred starting audio engine. \(error.localizedDescription)"
        }
    }
    private func stopListening() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
    }
    
    private func askMicPermission(completion: @escaping (Bool, String) -> ()) {
        SFSpeechRecognizer.requestAuthorization { status in
            let message: String
            var granted = false
            
            switch status {
            case .authorized:
                message = "Listening..."
                granted = true
                break
            case .denied:
                message = "Access to speech recognition is denied by the user."
                break
            case .restricted:
                message = "Speech recognition is restricted."
                break
            case .notDetermined:
                message = "Speech recognition has not been authorized, yet."
                break
            }
            completion(granted,message)
        }
    }
}
    

