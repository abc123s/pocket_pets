//
//  project3ModelTests.m
//  project3ModelTests
//
//  Created by Will Sun on 5/3/12.
//  Copyright (c) 2012 Harvard University. All rights reserved.
//

#import "project3ModelTests.h"
#import "Item.h"
#import "User.h"
#import "Action.h"
#import "Pet.h"
#import "BattleState.h"
#import "Battle.h"

@interface project3ModelTests ()

// private properties
@property (strong, nonatomic) NSDictionary *pets;
@property (strong, nonatomic) NSDictionary *items;
@property (strong, nonatomic) NSDictionary *actions;

@end


@implementation project3ModelTests

@synthesize pets = _pets;
@synthesize items = _items;
@synthesize actions = _actions;

- (void)setUp
{
    [super setUp];
    
    // load base dictionaries
    self.pets = [NSDictionary dictionaryWithContentsOfFile: 
                          [[NSBundle mainBundle] pathForResource:@"pets" 
                                                          ofType:@"plist"]];
    self.actions = [NSDictionary dictionaryWithContentsOfFile: 
                             [[NSBundle mainBundle] pathForResource:@"actions" 
                                                             ofType:@"plist"]];
    self.items = [NSDictionary dictionaryWithContentsOfFile: 
                           [[NSBundle mainBundle] pathForResource:@"items" 
                                                           ofType:@"plist"]];
    
    STAssertNotNil(self.pets, @"Cannot read pets file");
    STAssertNotNil(self.actions, @"Cannot read actions file");
    STAssertNotNil(self.items, @"Cannot read items file");    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

// Test pet initialization
- (void)testPetInitial
{
    Pet *pet1 = [[Pet alloc] initWithName:@"Pikachu" 
                         andLevel:1
                            andHp:-1
                           andExp:0
                       andActions:[NSArray arrayWithObject:@"Tackle"]];
    Pet *pet2 = [[Pet alloc] initWithName:@"Bulbasaur" 
                         andLevel:3
                            andHp:-1
                           andExp:0
                       andActions:[NSArray arrayWithObject:@"Tackle"]];
    Pet *pet3 = [[Pet alloc] initWithName:@"Charmander" 
                         andLevel:5
                            andHp:-1
                           andExp:0
                       andActions:[NSArray arrayWithObject:@"Tackle"]];
    
    NSDictionary *rPet1 = [self.pets objectForKey:@"Pikachu"];
    NSDictionary *rPet2 = [self.pets objectForKey:@"Bulbasaur"];
    NSDictionary *rPet3 = [self.pets objectForKey:@"Charmander"];
    
    STAssertEqualObjects(pet1.name, @"Pikachu", @"Pikachu name initialized incorrectly");
    STAssertEquals(pet1.level, 1, @"Pikachu level initialized incorrectly");
    STAssertEquals(pet1.exp, 0, @"Pikachu exp initialized incorrectly");
    STAssertEqualObjects(pet1.type, @"Ground", @"Pikachu type initialized incorrectly");
    STAssertEqualObjects(pet1.spritePath, @"Pikachusprite.jpg", @"Pikachu sprite initialized incorrectly");
    STAssertEqualObjects(pet1.battlePath, @"Pikachubattle.png", @"Pikachu battle sprite initialized incorrectly");
    STAssertEqualObjects(pet1.oppPath, @"Pikachuopp.png", @"Pikachu opp initialized incorrectly");
    STAssertEquals(pet1.full, [[rPet1 objectForKey:@"hpbase"] intValue] + [[rPet1 objectForKey:@"hpmult"] intValue] * pet1.level, @"Pikachu full hp initialized incorrectly");
    STAssertEquals(pet1.hp, pet1.full, @"Pikachu hp initialized incorrectly");
    STAssertEquals(pet1.attack, [[rPet1 objectForKey:@"attackbase"] intValue] + 
                   [[rPet1 objectForKey:@"attackmult"] intValue] * pet1.level, @"Pikachu atk initialized incorrectly");
    STAssertEquals(pet1.defense, [[rPet1 objectForKey:@"defensebase"] intValue] + 
                   [[rPet1 objectForKey:@"defensemult"] intValue] * pet1.level, @"Pikachu def initialized incorrectly");
    STAssertEquals(pet1.speed, [[rPet1 objectForKey:@"speedbase"] intValue] + 
                   [[rPet1 objectForKey:@"speedmult"] intValue] * pet1.level, @"Pikachu spd initialized incorrectly");
    STAssertEquals(pet1.special, [[rPet1 objectForKey:@"specialbase"] intValue] + 
                   [[rPet1 objectForKey:@"specialmult"] intValue] * pet1.level, @"Pikachu spc initialized incorrectly");
    NSArray *test = [NSArray arrayWithObject:[NSArray arrayWithObjects: @"Tackle", [NSNumber numberWithInt:2], nil]];
    STAssertEqualObjects(pet1.actions, test, @"Pikachu actions initialized incorrectly");
    
    STAssertEqualObjects(pet2.name, @"Bulbasaur", @"Bulbasaur name initialized incorrectly");
    STAssertEquals(pet2.level, 3, @"Bulbasaur level initialized incorrectly");
    STAssertEquals(pet2.exp, 0, @"Bulbasaur exp initialized incorrectly");
    STAssertEqualObjects(pet2.type, @"Ground", @"Bulbasaur type initialized incorrectly");
    STAssertEqualObjects(pet2.spritePath, @"Bulbasaursprite.jpg", @"Bulbasaur sprite initialized incorrectly");
    STAssertEqualObjects(pet2.battlePath, @"Bulbasaurbattle.png", @"Bulbasaur battle sprite initialized incorrectly");
    STAssertEqualObjects(pet2.oppPath, @"Bulbasauropp.png", @"Bulbasaur opp initialized incorrectly");
    STAssertEquals(pet2.full, [[rPet2 objectForKey:@"hpbase"] intValue] + [[rPet2 objectForKey:@"hpmult"] intValue] * pet2.level, @"Bulbasaur full hp initialized incorrectly");
    STAssertEquals(pet2.hp, pet2.full, @"Bulbasaur hp initialized incorrectly");
    STAssertEquals(pet2.attack, [[rPet2 objectForKey:@"attackbase"] intValue] + 
                   [[rPet2 objectForKey:@"attackmult"] intValue] * pet2.level, @"Bulbasaur atk initialized incorrectly");
    STAssertEquals(pet2.defense, [[rPet2 objectForKey:@"defensebase"] intValue] + 
                   [[rPet2 objectForKey:@"defensemult"] intValue] * pet2.level, @"Bulbasaur def initialized incorrectly");
    STAssertEquals(pet2.speed, [[rPet2 objectForKey:@"speedbase"] intValue] + 
                   [[rPet2 objectForKey:@"speedmult"] intValue] * pet2.level, @"Bulbasaur spd initialized incorrectly");
    STAssertEquals(pet2.special, [[rPet2 objectForKey:@"specialbase"] intValue] + 
                   [[rPet2 objectForKey:@"specialmult"] intValue] * pet2.level, @"Bulbasaur spc initialized incorrectly");
    
    STAssertEqualObjects(pet3.name, @"Charmander", @"Charmander name initialized incorrectly");
    STAssertEquals(pet3.level, 5, @"Charmander level initialized incorrectly");
    STAssertEquals(pet3.exp, 0, @"Charmander exp initialized incorrectly");
    STAssertEqualObjects(pet3.type, @"Ground", @"Charmander type initialized incorrectly");
    STAssertEqualObjects(pet3.spritePath, @"Charmandersprite.jpg", @"Charmander sprite initialized incorrectly");
    STAssertEqualObjects(pet3.battlePath, @"Charmanderbattle.png", @"Charmander battle sprite initialized incorrectly");
    STAssertEqualObjects(pet3.oppPath, @"Charmanderopp.png", @"Charmander opp initialized incorrectly");
    STAssertEquals(pet3.full, [[rPet3 objectForKey:@"hpbase"] intValue] + [[rPet3 objectForKey:@"hpmult"] intValue] * pet3.level, @"Charmander full hp initialized incorrectly");
    STAssertEquals(pet3.hp, pet3.full, @"Charmander hp initialized incorrectly");
    STAssertEquals(pet3.attack, [[rPet3 objectForKey:@"attackbase"] intValue] + 
                   [[rPet3 objectForKey:@"attackmult"] intValue] * pet3.level, @"Charmander atk initialized incorrectly");
    STAssertEquals(pet3.defense, [[rPet3 objectForKey:@"defensebase"] intValue] + 
                   [[rPet3 objectForKey:@"defensemult"] intValue] * pet3.level, @"Charmander def initialized incorrectly");
    STAssertEquals(pet3.speed, [[rPet3 objectForKey:@"speedbase"] intValue] + 
                   [[rPet3 objectForKey:@"speedmult"] intValue] * pet3.level, @"Charmander spd initialized incorrectly");
    STAssertEquals(pet3.special, [[rPet3 objectForKey:@"specialbase"] intValue] + 
                   [[rPet3 objectForKey:@"specialmult"] intValue] * pet3.level, @"Charmander spc initialized incorrectly");
}

// Test random pet initialization
- (void)testPetRandom
{
    // with only one "air" and "water" pet, we know what we'll get
    Pet *pet1 = [[Pet alloc] initRandomWithLevel:1 andType:@"Air"];
    Pet *pet2 = [[Pet alloc] initRandomWithLevel:1 andType:@"Water"];
    
    NSDictionary *rPet1 = [self.pets objectForKey:@"Pidgey"];
    NSDictionary *rPet2 = [self.pets objectForKey:@"Squirtle"];
    
    STAssertEqualObjects(pet1.name, @"Pidgey", @"Pidgey name initialized incorrectly");
    STAssertEquals(pet1.level, 1, @"Pidgey level initialized incorrectly");
    STAssertEquals(pet1.exp, 0, @"Pidgey exp initialized incorrectly");
    STAssertEqualObjects(pet1.type, @"Air", @"Pidgey type initialized incorrectly");
    STAssertEqualObjects(pet1.spritePath, @"Pidgeysprite.jpg", @"Pidgey sprite initialized incorrectly");
    STAssertEqualObjects(pet1.battlePath, @"Pidgeybattle.png", @"Pidgey battle sprite initialized incorrectly");
    STAssertEqualObjects(pet1.oppPath, @"Pidgeyopp.png", @"Pidgey opp initialized incorrectly");
    STAssertEquals(pet1.full, [[rPet1 objectForKey:@"hpbase"] intValue] + [[rPet1 objectForKey:@"hpmult"] intValue] * pet1.level, @"Pidgey full hp initialized incorrectly");
    STAssertEquals(pet1.hp, pet1.full, @"Pidgey hp initialized incorrectly");
    STAssertEquals(pet1.attack, [[rPet1 objectForKey:@"attackbase"] intValue] + 
                   [[rPet1 objectForKey:@"attackmult"] intValue] * pet1.level, @"Pidgey atk initialized incorrectly");
    STAssertEquals(pet1.defense, [[rPet1 objectForKey:@"defensebase"] intValue] + 
                   [[rPet1 objectForKey:@"defensemult"] intValue] * pet1.level, @"Pidgey def initialized incorrectly");
    STAssertEquals(pet1.speed, [[rPet1 objectForKey:@"speedbase"] intValue] + 
                   [[rPet1 objectForKey:@"speedmult"] intValue] * pet1.level, @"Pidgey spd initialized incorrectly");
    STAssertEquals(pet1.special, [[rPet1 objectForKey:@"specialbase"] intValue] + 
                   [[rPet1 objectForKey:@"specialmult"] intValue] * pet1.level, @"Pidgey spc initialized incorrectly");
    
    STAssertEqualObjects(pet2.name, @"Squirtle", @"Squirtle name initialized incorrectly");
    STAssertEquals(pet2.level, 1, @"Squirtle level initialized incorrectly");
    STAssertEquals(pet2.exp, 0, @"Squirtle exp initialized incorrectly");
    STAssertEqualObjects(pet2.type, @"Water", @"Squirtle type initialized incorrectly");
    STAssertEqualObjects(pet2.spritePath, @"Squirtlesprite.jpg", @"Squirtle sprite initialized incorrectly");
    STAssertEqualObjects(pet2.battlePath, @"Squirtlebattle.png", @"Squirtle battle sprite initialized incorrectly");
    STAssertEqualObjects(pet2.oppPath, @"Squirtleopp.png", @"Squirtle opp initialized incorrectly");
    STAssertEquals(pet2.full, [[rPet2 objectForKey:@"hpbase"] intValue] + [[rPet2 objectForKey:@"hpmult"] intValue] * pet2.level, @"Squirtle full hp initialized incorrectly");
    STAssertEquals(pet2.hp, pet2.full, @"Squirtle hp initialized incorrectly");
    STAssertEquals(pet2.attack, [[rPet2 objectForKey:@"attackbase"] intValue] + 
                   [[rPet2 objectForKey:@"attackmult"] intValue] * pet2.level, @"Squirtle atk initialized incorrectly");
    STAssertEquals(pet2.defense, [[rPet2 objectForKey:@"defensebase"] intValue] + 
                   [[rPet2 objectForKey:@"defensemult"] intValue] * pet2.level, @"Squirtle def initialized incorrectly");
    STAssertEquals(pet2.speed, [[rPet2 objectForKey:@"speedbase"] intValue] + 
                   [[rPet2 objectForKey:@"speedmult"] intValue] * pet2.level, @"Squirtle spd initialized incorrectly");
    STAssertEquals(pet2.special, [[rPet2 objectForKey:@"specialbase"] intValue] + 
                   [[rPet2 objectForKey:@"specialmult"] intValue] * pet2.level, @"Squirtle spc initialized incorrectly");
}

// Test level-up
- (void)testLevelUp
{
    Pet *pet1 = [[Pet alloc] initWithName:@"Pikachu"
                                andLevel:1 
                                   andHp:20 
                                  andExp:120 
                              andActions:[NSArray arrayWithObject:@"Tackle"]];
    NSMutableArray *oldActions = [[NSMutableArray alloc] init];
    for (NSArray *action in pet1.actions)
        [oldActions addObject:[action objectAtIndex:0]];
    NSMutableArray *new = [NSMutableArray arrayWithArray:[pet1 levelUp]];
    
    STAssertEqualObjects(pet1.name, @"Pikachu", @"Pikachu name incorrect");
    STAssertEquals(pet1.level, 2, @"Pikachu level incorrect");
    STAssertEquals(pet1.exp, 20, @"Pikachu exp incorrect");
    STAssertEqualObjects(pet1.type, @"Ground", @"Pikachu type incorrect");
    STAssertEquals(pet1.hp, pet1.full, @"Pikachu hp incorrect");
    STAssertEqualObjects(new, oldActions, @"Pikachu action list incorrect");
    
    // test corner case of exp = 100
    Pet *pet2 = [[Pet alloc] initWithName:@"Pikachu"
                                 andLevel:1 
                                    andHp:20 
                                   andExp:100 
                               andActions:[NSArray arrayWithObject:@"Tackle"]];
    oldActions = [[NSMutableArray alloc] init];
    for (NSArray *action in pet2.actions)
        [oldActions addObject:[action objectAtIndex:0]];
    new = [NSMutableArray arrayWithArray:[pet2 levelUp]];
    
    STAssertEqualObjects(pet2.name, @"Pikachu", @"Pikachu name incorrect");
    STAssertEquals(pet2.level, 2, @"Pikachu level incorrect");
    STAssertEquals(pet2.exp, 0, @"Pikachu exp incorrect");
    STAssertEqualObjects(pet2.type, @"Ground", @"Pikachu type incorrect");
    STAssertEquals(pet2.hp, pet2.full, @"Pikachu hp incorrect");
    STAssertEqualObjects(new, oldActions, @"Pikachu action list incorrect");
    
    // test new move (lvl 5 Pikachu move of Scratch)
    Pet *pet3 = [[Pet alloc] initWithName: @"Pikachu"
                                 andLevel:4
                                    andHp:20
                                   andExp:130
                               andActions:[NSArray arrayWithObject:@"Tackle"]];
    oldActions = [[NSMutableArray alloc] init];
    for (NSArray *action in pet3.actions)
        [oldActions addObject:[action objectAtIndex:0]];
    [oldActions addObject:@"Scratch"];
    new = [NSMutableArray arrayWithArray:[pet3 levelUp]];

    STAssertEqualObjects(pet3.name, @"Pikachu", @"Pikachu name incorrect");
    STAssertEquals(pet3.level, 5, @"Pikachu level incorrect");
    STAssertEquals(pet3.exp, 30, @"Pikachu exp incorrect");
    STAssertEqualObjects(pet3.type, @"Ground", @"Pikachu type incorrect");
    STAssertEquals(pet3.hp, pet3.full, @"Pikachu hp incorrect");
    STAssertEqualObjects(new, oldActions, @"Pikachu action list incorrect");
}

// Test action damage lookup
- (void)testDamageLookup
{
    
    int test1 = [Action lookupMoveDamageWithName:@"Tackle" 
                                       andAttack:10 
                                      andDefense:15 
                                        andSpeed:17 
                                      andSpecial:20];
    NSDictionary *tackle = [self.actions objectForKey:@"Tackle"];
    int check1 = ([[tackle objectForKey:@"damagebase"] intValue] + 
                  [[tackle objectForKey:@"attackmult"] intValue] * 10 +
                  [[tackle objectForKey:@"defensemult"] intValue] * 15 +
                  [[tackle objectForKey:@"speedmult"] intValue] * 17 +
                  [[tackle objectForKey:@"specialmult"] intValue] * 20)/100; 
    STAssertEquals(test1, check1, @"Tackle damage incorrect");
    
    int test2 = [Action lookupMoveDamageWithName:@"Wave" 
                                       andAttack:8 
                                      andDefense:13 
                                        andSpeed:5 
                                      andSpecial:20];
    NSDictionary *wave = [self.actions objectForKey:@"Wave"];
    int check2 = ([[wave objectForKey:@"damagebase"] intValue] + 
                  [[wave objectForKey:@"attackmult"] intValue] * 8 +
                  [[wave objectForKey:@"defensemult"] intValue] * 13 +
                  [[wave objectForKey:@"speedmult"] intValue] * 5 +
                  [[wave objectForKey:@"specialmult"] intValue] * 20)/100; 
    STAssertEquals(test2, check2, @"Wave damage incorrect");
}

// Test item lookup
- (void)testItemLookup
{
    NSDictionary *test1 = [Item lookupItemWithName:@"Pokeball"];
    NSDictionary *test2 = [Item lookupItemWithName:@"Potion"];
    
    NSDictionary *check1 = [self.items objectForKey:@"Pokeball"];
    NSDictionary *check2 = [self.items objectForKey:@"Potion"];
    
    STAssertEqualObjects(test1, check1, @"Pokeball items incorrect");
    STAssertEqualObjects(test2, check2, @"Potion items incorrect");
}

// Test store lookup
- (void)testStoreLookup
{
    NSArray *store = [Item store];
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (NSString *itemName in [self.items allKeys])
    {
        NSString *itemType = [[self.items objectForKey:itemName] objectForKey:@"type"];
        NSDictionary *new = [NSDictionary dictionaryWithObjectsAndKeys:itemName, @"name",
                             itemType, @"type",
                             [[self.items objectForKey:itemName] objectForKey:itemType], itemType, nil];
        [list addObject:new];
    }
    NSArray *check = [NSArray arrayWithArray:list];
    
    STAssertEqualObjects(store, check, @"Store not correct");
}

// Test check against previous game
- (void)testPrevGame
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"pets"];
    [defaults synchronize];
        
    // register user
    NSMutableDictionary *placeholder = [[NSMutableDictionary alloc] init];
    [placeholder setObject:@"" forKey:@"pets"];
    [placeholder setObject:@"" forKey:@"items"];
    [placeholder setObject:@"" forKey:@"alt"];
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults registerDefaults:placeholder];
    
    STAssertFalse([User noPets], @"Prev game incorrect");
    
    // save new pet
    NSDictionary *pet = [NSDictionary dictionaryWithObjectsAndKeys: @"Pikachu", @"name",
                         [NSNumber numberWithInt:1] , @"level", 
                         [NSNumber numberWithInt:-1], @"hp",
                         [NSNumber numberWithInt:0], @"xp", 
                         [NSArray arrayWithObject:@"Tackle"], @"actions", nil];
    NSMutableDictionary *pets = [[NSMutableDictionary alloc] init];
    [pets setObject:pet forKey:[pet objectForKey:@"name"]];
    
    defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:pets forKey:@"pets"];
    [defaults synchronize];
    
    STAssertFalse([User noPets], @"Prev game incorrect");
}

// Test init function
- (void)testNewGame
{
    [User initNewWithName:@"Pikachu"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *pet = [[defaults objectForKey:@"pets"] objectForKey:@"Pikachu"];
    STAssertEquals([[pet objectForKey:@"level"] intValue], 1, @"Level incorrect");
    STAssertEquals([[pet objectForKey:@"hp"] intValue], -1, @"HP incorrect");
    STAssertEquals([[pet objectForKey:@"xp"] intValue], 0, @"XP incorrect");
    STAssertEqualObjects([pet objectForKey:@"actions"], [NSArray arrayWithObject:@"Tackle"], @"Actions incorrect");
    
    // test clear and another new game
    [User initNewWithName:@"Bulbasaur"];
    
    defaults = [NSUserDefaults standardUserDefaults];
    pet = [[defaults objectForKey:@"pets"] objectForKey:@"Bulbasaur"];
    STAssertEquals([[pet objectForKey:@"level"] intValue], 1, @"Level incorrect");
    STAssertEquals([[pet objectForKey:@"hp"] intValue], -1, @"HP incorrect");
    STAssertEquals([[pet objectForKey:@"xp"] intValue], 0, @"XP incorrect");
    STAssertEqualObjects([pet objectForKey:@"actions"], [NSArray arrayWithObject:@"Tackle"], @"Actions incorrect");
}

// Test add new pet and item
- (void)testAdd
{
    // clear out defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDictionary alloc] init] forKey:@"pets"];
    [defaults setObject:[NSArray arrayWithObject:@"Super Potion"] forKey:@"items"];
    [defaults synchronize];

    [User addItem:@"Pokeball"];
    [User addItem:@"Potion"];
    [User addItem:@"Ultraball"];
    
    [User createPet:[[Pet alloc] initRandomWithLevel:1 andType:@"Air"]];
    [User createPet:[[Pet alloc] initRandomWithLevel:1 andType:@"Water"]];
    
    NSArray *items = [NSArray arrayWithObjects:@"Super Potion", @"Pokeball", @"Potion", @"Ultraball", nil];
    NSDictionary *pet1 = [NSDictionary dictionaryWithObjectsAndKeys: @"Pidgey", @"name",
                          [NSNumber numberWithInt:1] , @"level", 
                          [NSNumber numberWithInt:17], @"hp",
                          [NSNumber numberWithInt:0], @"xp", 
                          [NSArray arrayWithObject:@"Tackle"], @"actions", nil];
    NSDictionary *pet2 = [NSDictionary dictionaryWithObjectsAndKeys: @"Squirtle", @"name",
                          [NSNumber numberWithInt:1] , @"level", 
                          [NSNumber numberWithInt:28], @"hp",
                          [NSNumber numberWithInt:0], @"xp", 
                          [NSArray arrayWithObject:@"Tackle"], @"actions", nil];
    NSDictionary *pets = [NSDictionary dictionaryWithObjectsAndKeys:pet1, @"Pidgey", pet2, @"Squirtle", nil];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *testItems = [defaults objectForKey:@"items"];
    NSDictionary *testPets = [defaults objectForKey:@"pets"];
    
    STAssertEqualObjects(testItems, items, @"Items are not equivalent");
    STAssertEqualObjects(testPets, pets, @"Pets are not equivalent");
}

// Test update pet
- (void)testUpdatePet
{
    // clear out defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDictionary alloc] init] forKey:@"pets"];
    [defaults setObject:[NSArray arrayWithObject:@"Super Potion"] forKey:@"items"];
    [defaults synchronize];
    
    [User createPet:[[Pet alloc] initRandomWithLevel:1 andType:@"Air"]];
    
    // expect hp of 17, now update to 12; also increase xp to 20
    [User savePet:[[Pet alloc] initWithName:@"Pidgey" 
                                   andLevel:1 
                                      andHp:12 
                                     andExp:20
                                 andActions:[NSArray arrayWithObject:@"Tackle"]]];
    
    defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *pet = [[defaults objectForKey:@"pets"] objectForKey:@"Pidgey"];
    STAssertEqualObjects([pet objectForKey:@"name"], @"Pidgey", @"Names are not the same");
    STAssertEquals([[pet objectForKey:@"hp"] intValue], 12, @"HP does not match up");
    STAssertEquals([[pet objectForKey:@"xp"] intValue], 20, @"XP does not match up");
    STAssertEquals([[pet objectForKey:@"level"] intValue], 1, @"Level does not match up");
    STAssertEqualObjects([pet objectForKey:@"actions"], [NSArray arrayWithObject:@"Tackle"], @"Actions don't match up");     
}

// Test delete item
- (void)testDeleteItem
{
    // clear out defaults and start off with a Super Potion and a Pokeball
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[[NSDictionary alloc] init] forKey:@"pets"];
    [defaults setObject:[NSArray arrayWithObjects:@"Super Potion", @"Pokeball", nil] forKey:@"items"];
    [defaults synchronize];

    [User deleteItem:@"Super Potion"];
    
    // expect only the pokeball
    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *remainder = [defaults objectForKey:@"items"];
    STAssertEqualObjects(remainder, [NSArray arrayWithObject:@"Pokeball"], @"Items don't match up");
}

// Test battle mechanics
- (void)testBattle
{
    // two pidgeys
    Pet *pet1 = [[Pet alloc] initRandomWithLevel:1 andType:@"Air"];
    Pet *pet2 = [[Pet alloc] initRandomWithLevel:1 andType:@"Air"];
    Battle *battle = [[Battle alloc] initWithPet1:pet1 andPet2:pet2];
    
    
    // test attack
    BattleState *first = [battle doAction1:[NSArray arrayWithObjects:@"Tackle", [NSNumber numberWithInt:5], nil] 
                                andAction2:[NSArray arrayWithObjects:@"Tackle", [NSNumber numberWithInt:5], nil]];
    if ([first.attack1Message isEqualToString:@"Pidgey used Tackle on Pidgey. It misses!"])
        STAssertEquals(pet2.hp, 17, @"HP changed incorrectly");
    else 
        STAssertEquals(pet2.hp, 12, @"HP changed incorrectly");
    if ([first.attack2Message isEqualToString:@"Pidgey used Tackle on Pidgey. It misses!"])
        STAssertEquals(pet1.hp, 17, @"HP changed incorrectly");
    else 
        STAssertEquals(pet1.hp, 12, @"HP changed incorrecltly");
    
    // test item
    // load in a potion
    [User addItem:@"Potion"];
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:@"Potion", @"name", @"heal", @"type", [NSNumber numberWithInt:25], @"heal", nil];
    BattleState *second = [battle useItem1: item andAction2:[NSArray arrayWithObjects:@"Tackle", 
                                                                 [NSNumber numberWithInt:5], nil]];
    
    if ([second.attack2Message isEqualToString:@"Pidgey used Tackle on Pidgey. It misses!"])
        STAssertEquals(pet1.hp, 17, @"HP changed incorrectly"); // health is restored by potion
    else 
        STAssertEquals(pet1.hp, 12, @"HP changed incorrectly");
    
    // test flee
    BattleState *third = [battle flee:[NSArray arrayWithObjects:@"Tackle", [NSNumber numberWithInt:5], nil]];
    if ([third.attack2Message isEqualToString:@"Pidgey is left standing alone!"])
        STAssertTrue(third.flee, @"No flight!");
    else 
        STAssertFalse(third.flee, @"Flight is broken");
}
@end
