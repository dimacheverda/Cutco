//
//  CCGuidelinesTextView.m
//  Cutco
//
//  Created by Dima Cheverda on 11/8/14.
//  Copyright (c) 2014 Dima Cheverda. All rights reserved.
//

#import "CCGuidelinesTextView.h"
#import "UIFont+CCFont.h"

@interface CCGuidelinesTextView ()

@property (strong, nonatomic) UIImageView *imageView;

@end

@implementation CCGuidelinesTextView {
    NSTextStorage *textStorage;
    NSLayoutManager *layoutManager;
    NSTextContainer *textContainer;
}

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        textStorage = [[NSTextStorage alloc] init];
        layoutManager = [[NSLayoutManager alloc] init];
        textContainer = [[NSTextContainer alloc] init];
        [textStorage addLayoutManager:layoutManager];
        [layoutManager addTextContainer:textContainer];
        
        self.scrollIndicatorInsets = UIEdgeInsetsMake(64.0, 0.0, 0.0, 0.0);
        [self setTextContainerInset:UIEdgeInsetsMake(64.0 + 8.0, 8.0, 8.0, 5.0)];
        [self setTextAlignment:NSTextAlignmentLeft];
        [self setSelectable:NO];
        [self setEditable:NO];
        [self setScrollEnabled:YES];
        [self setTextColor:[UIColor darkGrayColor]];
        
        [self setupContent];
        
//        [self addSubview:self.imageView];
//        [self addLogoImageView];
    }
    return self;
}

- (void)setupContent {
    NSString *title1 = @"To: All Special Event and Road Show Personnel\n\n";
    NSString *title2 = @"Re: Standards and Expectations\n\n";
    NSString *header1 = @"It is paramount to the service of our members that we review and communicate the standards and expectations required from our Special Event and Road Show personnel.  The emphasis and focus will be that we achieve a standard and expectation that is consistent throughout ALL Costco Wholesale locations that you may conduct business in\n\n";
    NSString *header2 = @"First and foremost, we must always take care of the member.  Our directive is to provide the best quality service and/or merchandise at the lowest price.  In adhering to the standards and expectations listed below we can take giant strides forward in the consistency in service that we provide our members.\n\n";
    NSString *rules = @"•   Dress Neatly and Professionally\n    No Shorts and/or Leggings\n    No open toed shoes or any type of sandals\n    No hats (unless used with hairnets in conjunction with food handling events)\n    No T-Shirts, sweatshirts, tank tops or sleeveless shirts\n    No bare midriffs / cleavage\n    No visible tattoos, facial and/or tongue jewelry or strong perfume or cologne\n    Clean and neatly groomed hair\n•   Backpacks, Purses, Briefcases are not allowed in the work area\n•   Purchased or Unpaid Costco items can not be kept in your Road Show area.\n•   Sales or Demo area MUST be kept clean and safe at ALL times\n•   Please report any safety issues or concerns immediately to a Costco employee\n•   NO FOOD or DRINK is allowed in the work area (bottled water is acceptable)\n•   NO gum chewing and/or snacks in the work area\n•   Be attentive, helpful and courteous to all Costco members and employees\n•   Reading or the use of headphones, iPod’s, etc. is unacceptable\n•   The use of cell phones should be limited and strictly utilized for business use or only in the case of an emergency\n•   Sitting on chairs, on the floor, displays or on merchandise is not acceptable unless it is a medical necessity\n•   Each individual performing a sales or demo function must wear an identification badge in such form and with such information as determined by Costco Wholesale\n•   All Suppliers should have a (Costco Buyer approved) professional looking sign, posted during the event that states the dates that they will be at that particular location. This lets the members know the time frame that they have to purchase the item.\n•   All Marketing Materials such as, Signs, Flyers, Pallet wraps & Brochures must first be approved by the Special Event Buyer. Hand written signs are not permitted. Banners are not permitted that can be hung from the ceiling. Use of Costco’s logo or name is not permitted without written approval from Costco.\n•   The majority of Special Event items are cash-and-carry (i.e. the item sold leaves with the member that day).  However, some items might be special order – such as pianos, spas, sheds or furniture.  These items require a Costco Wholesale Special Order Purchase Form to be filled out by the member or by the staffer manning the event. All Special Orders are to be delivered to the address specified by the member on the Costco Wholesale Special Order Form.   No Special Orders will be allowed to be picked-up at a Costco location. Special Order (Hi- Cube) merchandise that is requested to be returned by the member will not go back to the warehouse. The Supplier will need to arrange for pick-up with the member.\n•   If you are unsure about member’s questions regarding concerns unrelated to your event or service, please locate a Costco employee to assist the member\n•   Please remember that the Warehouse Manager and Assistant Manager(s) are the ultimate decision makers for their respective warehouses.  If a problem arises, he or she should be involved so that the concern can be resolved in an expedient manner.\n\n";
    NSString *footer = @"THANK YOU FOR YOUR COOPERATION\n";
    
    NSMutableAttributedString *attrStrTitle1 = [[NSMutableAttributedString alloc] initWithString:title1];
    NSMutableAttributedString *attrStrTitle2 = [[NSMutableAttributedString alloc] initWithString:title2];
    NSMutableAttributedString *attrStrHeader1 = [[NSMutableAttributedString alloc] initWithString:header1];
    NSMutableAttributedString *attrStrHeader2 = [[NSMutableAttributedString alloc] initWithString:header2];
    NSMutableAttributedString *attrStrRules = [[NSMutableAttributedString alloc] initWithString:rules];
    NSMutableAttributedString *attrStrFooter = [[NSMutableAttributedString alloc] initWithString:footer];
    
    // title attributes
    NSMutableDictionary *titleAttr = [[NSMutableDictionary alloc] init];
    NSMutableParagraphStyle *titleParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    [titleParagrahStyle setLineSpacing:4.0];
    titleParagrahStyle.alignment = NSTextAlignmentLeft;
    [titleAttr setObject:titleParagrahStyle forKey:NSParagraphStyleAttributeName];
    [titleAttr setObject:[UIFont primaryCopyTypefaceWithSize:18.0] forKey:NSFontAttributeName];
    
    // header attributes
    NSMutableDictionary *headerAttr = [[NSMutableDictionary alloc] init];
    NSMutableParagraphStyle *headerParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    [headerParagrahStyle setLineSpacing:4.0];
    headerParagrahStyle.alignment = NSTextAlignmentLeft;
    [headerAttr setObject:headerParagrahStyle forKey:NSParagraphStyleAttributeName];
    [headerAttr setObject:[UIFont primaryCopyTypefaceWithSize:16.0] forKey:NSFontAttributeName];
    
    // rules attributes
    NSMutableDictionary *rulesAttr = [[NSMutableDictionary alloc] init];
    NSMutableParagraphStyle *rulesParagrahStyle = [[NSMutableParagraphStyle alloc] init];
    [rulesParagrahStyle setLineSpacing:4.0];
    rulesParagrahStyle.alignment = NSTextAlignmentLeft;
    [rulesAttr setObject:rulesParagrahStyle forKey:NSParagraphStyleAttributeName];
    [rulesAttr setObject:[UIFont primaryCopyTypefaceWithSize:15.0] forKey:NSFontAttributeName];
    
    // footer attributes
    NSMutableDictionary *footerAttr = [[NSMutableDictionary alloc] init];
    [footerAttr setObject:[UIFont primaryCopyTypefaceWithSize:17.0] forKey:NSFontAttributeName];
    
    // applying attributes
    [attrStrTitle1 addAttributes:titleAttr range:NSMakeRange(0, [attrStrTitle1 length])];
    [attrStrTitle2 addAttributes:titleAttr range:NSMakeRange(0, [attrStrTitle2 length])];
    [attrStrHeader1 addAttributes:headerAttr range:NSMakeRange(0, [attrStrHeader1 length])];
    [attrStrHeader2 addAttributes:headerAttr range:NSMakeRange(0, [attrStrHeader2 length])];
    [attrStrRules addAttributes:rulesAttr range:NSMakeRange(0, [attrStrRules length])];
    [attrStrFooter addAttributes:footerAttr range:NSMakeRange(0, [attrStrFooter length])];
    
    // concatenating strings
    NSMutableAttributedString *fullString = [[NSMutableAttributedString alloc] init];
    [fullString appendAttributedString:attrStrTitle1];
    [fullString appendAttributedString:attrStrTitle2];
    [fullString appendAttributedString:attrStrHeader1];
    [fullString appendAttributedString:attrStrHeader2];
    [fullString appendAttributedString:attrStrRules];
    [fullString appendAttributedString:attrStrFooter];
    
    self.attributedText = fullString;
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    CGFloat imageActualWidth = 402.0;
//    CGFloat imageActualHeight = 107.0;
//    CGFloat imageOffset = 20.0;
//    
//    _imageView.frame = CGRectMake(imageOffset,
//                                  64.0 + 4.0,
//                                  CGRectGetWidth(self.frame) - imageOffset * 2,
//                                  (CGRectGetWidth(self.frame) - imageOffset * 2) / imageActualWidth * imageActualHeight);
//    // Adding to exclusion paths
//    UIBezierPath* exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(_imageView.frame.origin.x - 3.0,
//                                                                              _imageView.frame.origin.y - 10.0,
//                                                                              _imageView.frame.size.width + 3.0,
//                                                                              _imageView.frame.size.height + 10.0)];
//    self.textContainer.exclusionPaths = @[exclusionPath];
}

- (void)addLogoImageView {
    CGFloat imageActualWidth = 402.0;
    CGFloat imageActualHeight = 107.0;
    CGFloat imageOffset = 20.0;
    
    self.imageView.frame = CGRectMake(imageOffset,
                                      64.0 + 4.0,
                                      CGRectGetWidth(self.frame) - imageOffset * 2,
                                      (CGRectGetWidth(self.frame) - imageOffset * 2) / imageActualWidth * imageActualHeight);
    
    // Adding to exclusion paths
    UIBezierPath* exclusionPath = [UIBezierPath bezierPathWithRect:CGRectMake(0.0,
                                                                              self.imageView.frame.origin.y,
                                                                              self.frame.size.width,
                                                                              self.imageView.frame.size.height + 10.0)];
    [self addSubview:self.imageView];
    
    self.textContainer.exclusionPaths = @[exclusionPath];

}

#pragma mark - Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"costco_logo_guidelines"];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

@end
