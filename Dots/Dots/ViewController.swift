//
//  ViewController.swift
//  Dots
//
//  Created by Leon Vladimirov on 8/14/18.
//  Copyright © 2018 Leon Vladimirov. All rights reserved.
//

import UIKit
import GameplayKit
import AudioToolbox
//bugs to fix: None - Stable
//Features to add:
//1. Better Color Scheme

extension Int {
    static func random(min: Int, max: Int) -> Int {
        precondition(min <= max)
        let randomizer = GKRandomSource.sharedRandom()
        return min + randomizer.nextInt(upperBound: max - min + 1)
    }
}


extension UIView {
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimerBar.layer.cornerRadius = 2
        
        TimerBar.clipsToBounds = true
        
        DotsContainer.isHidden = true
        
        Guess1.isHidden = true
        
        Guess2.isHidden = true

        Guess3.isHidden = true
        
        GameOverLabel.isHidden = true
        
        StatsLabel.isHidden = true
        
        GuessTime.isHidden = true
        
        LifeCounterLabel.text = "\(LifeCounter) X"
        
        self.view.addSubview(DotsContainer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //all of the connections
    @IBOutlet weak var Rules: UILabel!
    
    @IBOutlet weak var LifeCounterLabel: UILabel!
    
    @IBOutlet weak var Guess1: UIButton!
    
    @IBOutlet weak var Guess2: UIButton!
    
    @IBOutlet weak var Guess3: UIButton!
    
    @IBOutlet weak var TimerBar: UIProgressView!
    
    @IBOutlet weak var DotsContainer: UIView!
    
    @IBOutlet weak var CorrectOrWrongLabel: UILabel!
    
    @IBOutlet weak var LevelLabel: UILabel!
    
    @IBOutlet weak var GenerateBoardButton: UIButton!
    
    
    @IBOutlet weak var GameOverLabel: UILabel!
    
    @IBOutlet weak var StatsLabel: UILabel!
    
    @IBOutlet weak var GuessTime: UILabel!
    
    var InitializationCounter: Int = 0
    
    var Level: Int = 1
    
    var MaxAmountOfDots: Int = 5
    
    var AmountOfDots: Int = 0
    
    var countdownTimer: Timer!
    
    var TotalTime: Int = 10
    
    var AverageGuessingTime: Int = 0
    
    let shapeLayer = CAShapeLayer()
    
    var SubLevelCounter: Int = 0
    
    var LifeCounter: Int = 2
    
    var Streak: Int = 0
    
    var TimerValues = [Int]()
    
    var StatsTimer = Timer()
    var StatsCounter = 0
    
    func StartStatsTimer() {
        StatsTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(StatsTimerAction), userInfo: nil, repeats: true)
    }
    
    @objc func StatsTimerAction() {
        StatsCounter += 1
        
    }
    
    func CancelStatsTimer() {
        
        TimerValues.append(StatsCounter)
        
        print(TimerValues)
        
        StatsCounter = 0
        
        StatsTimer.invalidate()
    }
// 5 Second Timer Module. 2 events happen at the same time. The animation starts and timer starts. They are synched.
    
    var counter = 4
    var timer = Timer()
    // start timer
    func startPhysicalTimer() {
        // start the timer
        timer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    // stop timer
    func cancelTimer() {
  
        counter = 4
        
        TimerBar.progress = 0
        
        timer.invalidate()
    }
    
    // called every time interval from the timer
    @objc func timerAction() {
        TimerBar.progress += 0.25
        if counter != 0 {
         counter -= 1
        } else {
            LifeCounter -= 1
            LifeCounterLabel.text = "\(LifeCounter) X"
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))

            if LifeCounter == 0 {
                GameOver()
            }
            cancelTimer()
        }
    }
    

   // This is the end of the Timer moduler
    

   //Button press handler
    
    @IBAction func ButtonPressHandler(_ sender: AnyObject) {
        
        guard let button = sender as? UIButton else {return}
        
        HideEllementsAfterGuess()
        
        
        switch button.tag {
        case 1:
            if Guess1.currentTitle == "\(AmountOfDots)" {
                Streak += 1
                CorrectOrWrongLabel.text = "Score \(Streak)"
            } else {
                if Streak != 0 {
                    Streak -= 1
                }
                CorrectOrWrongLabel.text = "Score \(Streak)"
                LifeCounter -= 1
                LifeCounterLabel.text = "\(LifeCounter) X"
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
          
                if LifeCounter == 0 {
                    GameOver()
                }

            }
            
     
        case 2:
            if Guess2.currentTitle == "\(AmountOfDots)" {
                Streak += 1
                CorrectOrWrongLabel.text = "Score \(Streak)"
            } else {
                if Streak != 0 {
                    Streak -= 1
                }
                CorrectOrWrongLabel.text = "Score \(Streak)"
                LifeCounter -= 1
                LifeCounterLabel.text = "\(LifeCounter) X"
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
          
                if LifeCounter == 0 {
                    GameOver()
                }
            }
        
 
            
        case 3:
            if Guess3.currentTitle == "\(AmountOfDots)" {
                Streak += 1
                CorrectOrWrongLabel.text = "Score \(Streak)"
            } else {
                if Streak != 0 {
                    Streak -= 1
                }
                
                CorrectOrWrongLabel.text = "Score \(Streak)"
                LifeCounter -= 1
                LifeCounterLabel.text = "\(LifeCounter) X"
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
             
                if LifeCounter == 0 {
                GameOver()
                }
            }

            
            
        default:
            print("ERROR")
        }
        
        
        if Streak > UserDefaults.standard.integer(forKey: "MaxStreak"){
            UserDefaults.standard.set(Streak, forKey: "MaxStreak" )
        }
        
        CancelStatsTimer()
        
        if LifeCounter != 0 {
         cancelTimer()
         GenerateGame(nil)
        }
    }
    
    //called each time to generate a new board, reset all variables, hide elements
    @IBAction func GenerateGame(_ sender: UIButton?) {
        
        Rules.isHidden = true
        
        if CorrectOrWrongLabel.text == "Game Over" {
            CorrectOrWrongLabel.text = "Score \(Streak)"
        }
        
        if LifeCounter == 0   {
            SubLevelCounter = 0
            LifeCounter = 2
            LifeCounterLabel.text = "\(LifeCounter) X"
            DotsContainer.layer.cornerRadius = 0
            DotsContainer.clipsToBounds = false
            DotsContainer.dropShadow(color: .white, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)

            GameOverLabel.isHidden = true
            
            StatsLabel.isHidden = true
            
            GuessTime.isHidden = true
        }
        
        InitializationCounter += 1
        
        SubLevelCounter += 1

        counter = 4
        
        startTimer()
        
        StartStatsTimer()
        
        if InitializationCounter != 1 {
            
         RefreshPageToGenerateNewBoard()

        } else {
            DotsContainer.isHidden = false 
        }
        
        if InitializationCounter % 5 == 0 {
            
            Level += 1
            
            LevelLabel.text = "LVL \(Level)"
            
            MaxAmountOfDots += 5
                        
            SubLevelCounter = 0

        }
        
        AmountOfDots = Int.random(min: 1, max: MaxAmountOfDots)
        
        GenerateDotBoard(AmountOfDots: AmountOfDots, RadiusValue: GenerateRadius())
        
        SetGuessValues(AmountOfDots: AmountOfDots)
        
        print(AmountOfDots)

        
    }
    
    
    func startTimer() {
        startPhysicalTimer()
    }

    func GameOver() {
        
        Streak = 0
        
        CorrectOrWrongLabel.text = "Game Over"
        
        cancelTimer()
        
        CancelStatsTimer()
        
        RefreshPageToGenerateNewBoard()
        
        DotsContainer.layer.cornerRadius = 10
        
        DotsContainer.clipsToBounds = true
        
        DotsContainer.dropShadow(color: .gray, opacity: 0.5, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        
        HideEllementsAfterGuess()
        
        // set InitializationCounter to zero for new game, bring all end game elements to front(game over, stats, share). show "Play Again"
        
        InitializationCounter = 0
        GenerateBoardButton.setTitle("Play Again", for: .normal)
        GameOverLabel.isHidden = false
        StatsLabel.text = "HighScore: \(UserDefaults.standard.integer(forKey: "MaxStreak"))"
        GuessTime.text = "Guess Time: \(TimerValues.reduce(0, +) / TimerValues.count) sec."
        StatsLabel.isHidden = false
        
        GuessTime.isHidden = false
        
        view.bringSubviewToFront(GameOverLabel)
        view.bringSubviewToFront(StatsLabel)
        view.bringSubviewToFront(GuessTime)
    }
    
    func HideEllementsAfterGuess() {
        Guess1.isHidden = true
        
        Guess2.isHidden = true
        
        Guess3.isHidden = true
        
        GenerateBoardButton.isHidden = false
    }
    
    func HideEllementsForGuess() {
        
        Guess1.isHidden = false
        
        Guess2.isHidden = false
        
        Guess3.isHidden = false
        
        GenerateBoardButton.isHidden = true
    }
    
    func GenerateMultiplyer() -> Int {
        let Array = [-1, 1]
        
        return Array[Int.random(min: 0, max: 1)]
    }
    
    func ChooseRandomNumber() -> Int {
        return Int.random(min: 1, max: 5)
        
    }
    func ChooseRandomButton() -> Int {
        return Int.random(min: 1, max: 3)
    }
    
    func SetGuessValues(AmountOfDots: Int) {
        let NumberOfButton = ChooseRandomButton()
        print(ChooseRandomButton())
        if NumberOfButton == 1 {
            Guess1.setTitle("\(AmountOfDots)", for: .normal)
            Guess2.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)
            Guess3.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)
            
        }
        if NumberOfButton == 2 {
            Guess2.setTitle("\(AmountOfDots)", for: .normal)
            Guess1.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)
            Guess3.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)

        }
        if NumberOfButton == 3 {
            Guess3.setTitle("\(AmountOfDots)", for: .normal)
            Guess1.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)
            Guess2.setTitle("\(abs(AmountOfDots + GenerateMultiplyer() * ChooseRandomNumber()))", for: .normal)
        }
        HideEllementsForGuess()
    }
    //Dot size and color generating functions BEGIN
    func GenerateRadius() -> Int {
        let RadiusValue = Int.random(min: 7, max: 12)
        return RadiusValue
    }
   //This function can Generate Different Colors. Not used for release
    func GenerateColor() -> UIColor {
        let pink = UIColor(red:0.95, green:0.48, blue:0.66, alpha:1.0)
        let purple = UIColor(red: 34.0/255.0, green: 30.0/255.0, blue: 65.0/255.0, alpha: 1)
        let mustard = UIColor(red:0.95, green:0.83, blue:0.00, alpha:1.0)
        let colorArray = [pink, purple, mustard]
        
        return colorArray[1]
    }
    //Dot size and color generating functions END
    
    func DrawDot(Point: CGPoint, RadiusValue: Int){
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: Point.x, y: Point.y), radius: CGFloat(RadiusValue), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = GenerateColor().cgColor
        //you can change the stroke color
//        shapeLayer.strokeColor = GenerateColor().cgColor
        //you can change the line width
        shapeLayer.lineWidth = 3.0
        
        
        
        DotsContainer.layer.addSublayer(shapeLayer)
    }
    
    func RefreshPageToGenerateNewBoard() {
        for layer: CALayer in DotsContainer.layer.sublayers! {
            layer.removeFromSuperlayer()

        }
        
    }
    

    func distance(firstPoint: CGPoint, secondPoint: CGPoint) -> Int {
        let xDist = firstPoint.x - secondPoint.x
        let yDist = firstPoint.y - secondPoint.y
        return Int(sqrt((xDist * xDist) + (yDist * yDist)))
    }
    
    // CheckIfOverlapping() checks if the newly generated coordinates overlap already generated ones by comparing newly generated point to all the exisitng ones
    
    func CheckIfOverlapping(Points: [CGPoint], x: Int, y: Int, RadiusValue: Int) -> Bool {
        for i in 0...Points.count - 1 {
            if distance(firstPoint: Points[i], secondPoint: CGPoint(x: x, y: y)) < 2 * RadiusValue + 10 {
                return true
            }
        }

        return false
    }
    
    func GenerateDotBoard(AmountOfDots: Int, RadiusValue: Int) {
        var Points = [CGPoint]()
        var Point: CGPoint
        var CoordinateX: Int = 0
        var CoordinateY: Int = 0
        while Points.count != AmountOfDots  {
            
            CoordinateX = Int.random(min: Int(DotsContainer.bounds.minX) + RadiusValue, max: Int(DotsContainer.bounds.maxX) - RadiusValue)
            CoordinateY = Int.random(min: Int(DotsContainer.bounds.minY) + RadiusValue, max: Int(DotsContainer.bounds.maxY) - RadiusValue)
            Point = CGPoint(x: CoordinateX, y: CoordinateY)
            
            //The statament below protects code from first initialization
            if Points.count == 0 {
                Points.append(Point)
            }
            //places the dot and checks if it overlaps the existing ones
            else if Points.contains(Point) == false && CheckIfOverlapping(Points: Points, x: CoordinateX, y: CoordinateY, RadiusValue: RadiusValue) == false {
                Points.append(Point)
            }
            
        }
        for i in 0...AmountOfDots - 1 {
            DrawDot(Point: Points[i], RadiusValue: GenerateRadius())
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

