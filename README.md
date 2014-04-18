CircleMenu
==========

It’s a Menu with some animation

Use Example : (viewDidLoad)
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setUserInteractionEnabled:YES];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSArray *icons = [[NSArray alloc] initWithObjects:@"17.png", @"10.png", @"13.png", @"8.png", @"7.png", @"12.png", nil];
    
    CircleMenu *phony_menu = [[CircleMenu alloc] initMenu];
    [phony_menu set_icons:icons];
    phony_menu.delegate = self;
    [self.view addSubview:phony_menu];
}
-(void)item_chosen:(NSInteger)chosen_number
{
    NSLog(@"%d", chosen_number);
}
