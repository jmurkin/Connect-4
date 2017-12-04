//
//  ViewController.swift
//  Connect 4
//
//  Created by Mac on 30/11/2017.
//  Copyright © 2017 Jake Murkin. All rights reserved.
// 1 = red, 2 = yellow
//animate the counters, make them scale up when picked instead of instantly appearing
//animate the winning combination, make them grow in a sequence
//add ai?

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblWinner: UILabel!
    @IBOutlet weak var btnRestart: UIButton!
    var currPlayer = 1
    var complete = false
    //outer count is number of rows, inner is cols.
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 7), count: 6)

    
    //this is the function ran when the user presses a square
    //it checks every square to see if there is a winning combination
    @IBAction func btnPiece(_ sender: AnyObject) {
        if complete == false {
            convertToIndex(tag: sender.tag, player: currPlayer)
            //run a for loop through all x and y for grid to check if there is a winner
            var i = 0 // y
            var j = 0 // x
        
            while i < 6 {
                while j < 7 {
                    checkNeighbours(x: j, y: i)
                    j = j + 1
                }
                j = 0
                i = i + 1
            }
       
            //checkNeighbours(x: 0, y: 0)
            //print(grid)
        }
    }
    
    //converts the tag of a button to its respective index in the grid array
    func convertToIndex(tag: Int, player: Int) -> Void{
        
        let strTag: NSString = String(tag) as NSString
        if strTag.length == 1 {
            let x = tag - 1
            //let y = 0
            //print("y: " + String(y) + ", x: " + String(x))
            showCounter(player: player, x: x)
        } else {
            var x = Int(strTag.substring(from: 1))
            x = x! - 1
            //let y = Int(strTag.substring(to: 1))
           // print("y: " + String(describing: y!) + ", x: " + String(describing: x!))
            showCounter(player: player, x: x!)
        }
        
    }
    
    //places the counter where the user has clicked, but at the lowest y then makes it visible
    func showCounter(player: Int, x: Int) -> Void {
        var found = false
        var y = 0
        while found == false {
            if grid[y][x] == 0 {
                grid[y][x] = player
                found = true
                //print("y: " + String(y) + ", x: " + String(x))
               // used to set image of button need to convert index to tag again
                let newTag = convertToTag(x: x, y: y)
                //print("y: " + String(y) + ", x: " + String(x))

                
                if let button = self.view.viewWithTag(newTag) as? UIButton{
                    if player == 1 {
                        button.setImage(UIImage(named: "red.png"), for: [])
                        currPlayer = 2
                    } else {
                        button.setImage(UIImage(named: "yellow.png"), for: [])
                        currPlayer = 1
                    }

                }
 
            } else if y == 5 {
                found = true
                print("no spaces!")
            } else {
                y = y + 1
            }
            
            
        }
        
        
    }
    
    //converts index of grid array back to a tag
    func convertToTag(x: Int, y: Int) -> Int {

        var varX = x
        varX = x + 1
        let stringTag = String(y) + String(varX)
        let newTag = Int(stringTag)
        return newTag!
    }
    
    //checks every neighbouring square to a given one via x and y index of the grid array
    func checkNeighbours(x: Int, y: Int) -> Void {
        //stores x and y of neighbour cell that is the same colour
        let step = 0
        //var count = 0
        var xoff = -1
        var yoff = -1
        while xoff < 2 {
            while yoff < 2{
                let tempX = x + xoff
                let tempY = y + yoff
              /*
                //  print("tempX = " + String(tempX))
             //   print("tempY = " + String(tempY))
                if (checkWall(x: tempX, y: tempY) == false){
                    if(grid[tempY][tempX] == grid[y][x] && grid[y][x] != 0){
                        if(tempX == x && tempY == y ){
                            
                        } else {
                            print("tempX = " + String(tempX))
                            print("tempY = " + String(tempY))
                            count = count + 1
                        }
                       
                    }
                }
 */                 //checks to see if that neighbouring square is the same colour
                    checkWin(x2: tempX, y2: tempY, x1: x, y1: y, step: step)
                
                
                yoff = yoff + 1
                
            }
            yoff = -1
            xoff = xoff + 1
        }
        //print("Checked")
        //print("Count: " + String(count))
        
    }
    
    //recursive function which calcuates the distance between two cells then checks the next
    //cell by adding the found distance and checking if its the same colour
    //repeat until win or no win
    func checkWin(x2: Int, y2: Int, x1:Int, y1: Int, step: Int) -> Void {
    if complete == false {
        var stepVar = step
        let stepX = x2 - x1
        let stepY = y2 - y1
        
        if(stepX == 0 && stepY == 0){
            //do nothing
        } else {
            
            //first check
            if step == 0{
                if(checkWall(x: x2, y: y2) == false){
                    if(grid[y2][x2] == grid[y1][x1] && grid[y1][x1] != 0){
                        if(x1 == x2 && y1 == y2){
                            // do nothing! used in edge case where it picks itself as nearest neighbour
                        } else {
                            //check next peice in line
                            stepVar = step + 1
                            //print("step = " + String(stepVar))
                            //if they are the same colour then check again
                            checkWin(x2: x2, y2: y2, x1: x1, y1: y1, step: stepVar)
                        }
                    }
                }
                
                
                
            }
            
            
            let newX = x2 + stepX
            let newY = y2 + stepY
            //check if wall
            if(checkWall(x: newX, y: newY) == false) {
                //check if new peice is same colour
                if(grid[newY][newX] == grid[y1][x1] && grid[y2][x2] != 0){
                    
                    //check next peice in line
                    if step != 2 {
                        stepVar = step + 1
                       //print("step = " + String(stepVar))
                        checkWin(x2: newX, y2: newY, x1: x2, y1: y2, step: stepVar)
                    } else {
                        //WINNER!
                        //print(grid)
                        gameWon()
                        //print("WINNER! y4: " + String(y2) + ", x4: " + String(x2) + ", y3: " + String(y1) + ", x3: " + String(x1))
                    }
                    
                    
                }
            }
            
            
        }
        }
    }
    
    func checkWall(x: Int, y: Int) -> Bool {
        if(x > -1 && x < 7 && y > -1 && y < 6){
            //print("false for tempX : " + String(x) + " and tempY: " + String(y))
            return false
        }
           // print("true for tempX : " + String(x) + " and tempY: " + String(y))
        return true
        
        
    }

    func gameWon() -> Void {
        complete = true
        slideIn()
        if currPlayer == 2 {
            lblWinner.text = ("Reds Win!")
            lblWinner.textColor = UIColor.red
        } else {
            lblWinner.text = ("Yellows Win!")
            lblWinner.textColor = UIColor.orange
        }
        
    }
    
    func slideIn() -> Void {
        
        UIView.animate(withDuration: 1, animations: {
            self.lblWinner.center = CGPoint(x: self.lblWinner.center.x + 500, y: self.lblWinner.center.y)
            self.btnRestart.center = CGPoint(x: self.btnRestart.center.x + 500, y: self.btnRestart.center.y)
        })
    }
    
    func slideOut() -> Void {
        lblWinner.center = CGPoint(x: lblWinner.center.x - 500, y: lblWinner.center.y)
        btnRestart.center = CGPoint(x: btnRestart.center.x - 500, y: btnRestart.center.y)
    }
    
    //runs when the user presses the play again button
    //clears the grid array and resests the board
    @IBAction func reset(_ sender: Any) {
        complete = false
        currPlayer = 1
        slideOut()
        var i = 0
        var j = 0
        while j < 6 {
            while i < 7 {
                grid[j][i] = 0
                let tag = convertToTag(x: i, y: j)
                if let button = self.view.viewWithTag(tag) as? UIButton{
                    button.setImage(nil, for: [])
                }
                i = i + 1
            }
            i = 0
            j = j + 1
            //print(String(j))
        }
       // print(grid)
    }

 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        slideOut()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

