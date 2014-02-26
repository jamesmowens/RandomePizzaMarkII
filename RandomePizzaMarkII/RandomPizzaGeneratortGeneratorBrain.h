//
//  RandomPizzaGeneratortGeneratorBrain.h
//  RandomePizzaMarkII
//
//  Created by James Owens on 1/30/14.
//  Copyright (c) 2014 James Owens. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topping.h"

@interface RandomPizzaGeneratortGeneratorBrain : NSObject
@property (nonatomic,strong)NSArray *toppings; //all of the possible toppings
@property (nonatomic, strong) NSArray *toppingsPool; //the toppings to be selected from when generate pressed


-(NSArray *)generateWithNumberOfToppings:(int)number; 
@end
