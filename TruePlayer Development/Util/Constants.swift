//
//  Constants.swift
//  TruePlayer Development
//
//  Created by Vijay Rathore on 13/05/23.
//

import Foundation
import UIKit
import CoreLocation

struct Constants {
    
    class Category {
        public static let basic_skills = "BASICSKILLS"
        public static let ball_mastery = "BALLMASTERY"
        public static let elite_drill = "ELITEDRILL"
        public static let foot_speed = "FOOTSPEED"
        public static let attacking_moves = "ATTACKINGMOVES"
        
        static func getCategoryName(by categoryId : String) -> String{
            switch categoryId {
            case basic_skills : return "Basic Skills"
            case ball_mastery : return "Ball Mastery"
            case elite_drill : return "Elite Drill"
            case foot_speed: return "Foot Speed"
            case attacking_moves : return "Attacking Moves"
            default:
                return ""
            }
        }
    }
   
    
    struct StroyBoard {
        
        static let signInViewController = "signInVC"
        static let tabBarViewController = "tabbarVC"
      
    }

    public static var currentDate = Date()
    public static let quotes = ["Age is no barrier. It’s a limitation you put on your mind."
               , "I always felt that my greatest asset was not my physical ability, it was my mental ability."
               , "A trophy carries dust. Memories last forever.","It’s not the will to win that matters—everyone has that. It’s the will to prepare to win that matters."
       ,"Persistence can change failure into extraordinary achievement.","I’ve learned that something constructive comes from every defeat."
       ,"Make sure your worst enemy doesn't live between your own two ears."
               ,"If you can’t outplay them, outwork them.","Most people never run far enough on their first wind to find out they’ve got a second."
       ,"Do you know what my favorite part of the game is? The opportunity to play.","The difference between the impossible and the possible lies in a person’s determination.",
               "Champions keep playing until they get it right.",

               "You were born to be a player. You were meant to be here. This moment is yours.",

               "If you fail to prepare, you’re prepared to fail.",

               "What you lack in talent can be made up with desire, hustle, and giving 110% all the time.",

               "Persistence can change failure into extraordinary achievement.",

               "The principle is competing against yourself. It’s about self-improvement, about being better than you were the day before.",

               "You are never really playing an opponent. You are playing yourself, your own highest standards, and when you reach your limits, that is real joy.",

               "The more difficult the victory, the greater the happiness in winning.",

               "Most talented players don’t always succeed. Some don’t even make the team. It’s more what’s inside.",

               "You’ve got to take the initiative and play your game. In a decisive set, confidence is the difference.",

               "The mind is the limit. As long as the mind can envision the fact that you can do something, you can do it, as long as you really believe 100 percent.",

               "I never left the field saying I could have done more to get ready and that gives me peace of mind.",

               "Always make a total effort, even when the odds are against you.",

               "To uncover your true potential you must first find your own limits and then you have to have the courage to blow past them.",

               "You can motivate by fear, and you can motivate by reward. But both those methods are only temporary. The only lasting thing is self motivation.",

               "You find that you have peace of mind and can enjoy yourself, get more sleep, and rest when you know that it was a one hundred percent effort that you gave–win or lose.",

               "If you can believe it, the mind can achieve it.",

               "Obstacles don’t have to stop you. If you run into a wall, don’t turn around and give up. Figure out how to climb it, go through it, or work around it.",

               "Make each day your masterpiece.",

               "Excellence is the gradual result of always striving to do better.",

               "Win If You Can, Lose If You Must, But NEVER QUIT!",

               "If you have everything under control, you’re not moving fast enough.",

               "What do do with a mistake: recognize it, admit it, learn from it, forget it.",

               "Push yourself again and again. Don’t give an inch until the final buzzer sounds.",

               "If you aren’t going all the way, why go at all?",

               "You can’t put a limit on anything. The more you dream, the farther you get.",

               "Do not let what you can not do interfere with what you can do.",

               "The will to win is important, but the will to prepare is vital.",

               "Adversity cause some men to break; others to break records.",

               "Never let your head hang down. Never give up and sit down and grieve. Find another way.",

               "There are only two options regarding commitment. You’re either IN or you’re OUT. There is no such thing as life in-between.",

               "You’re only as strong as your weakest link.",

               "Only he who can see the invisible can do the impossible.",

               "There may be people that have more talent than you, but there's no excuse for anyone to work harder than you do.",

               "Set your goals high, and don't stop til you get there.",

               "Nobody who ever gave his best regretted it.",

               "When I go out there I have no pity on my brother. I am there to win.",

               "You have to expect things of yourself before you can do them.",

               "If you train hard, you'll not only be hard, you'll be hard to beat.",

               "Without self-discipline, success is impossible, period.",

               "Just keep going. Everybody gets better if they keep at it."]
}

