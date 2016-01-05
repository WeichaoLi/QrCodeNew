//
//  QrcodeDataViewController.m
//  QrCodeNew
//
//  Created by 李伟超 on 15/12/30.
//  Copyright © 2015年 LWC. All rights reserved.
//

#import "QrcodeDataViewController.h"
#import "CodeDataTableViewCell.h"
#import "CodeType.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>

@interface QrcodeDataViewController ()<UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) CodeType *codeType;

@end

static NSString *identifier = @"CodeDataTableViewCell";

@implementation QrcodeDataViewController

- (void)loadView {
    [super loadView];
    
    _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    if (QRCODE_SYSTEM_VERSIONS_GREATER_THAN_OR_EQUAL(7.0)) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    _myTableView.backgroundColor = [UIColor clearColor];
    _myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _myTableView.estimatedRowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:_myTableView];
    
    UIView *footer = [UIView new];
    [_myTableView setTableFooterView:footer];
    
    [_myTableView registerClass:[CodeDataTableViewCell class] forCellReuseIdentifier:identifier];
    
    self.navigationItem.title = @"扫描结果";
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    view.backgroundColor = [UIColor whiteColor];
    [_myTableView setTableHeaderView:view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _codeType = [[CodeType alloc] initWithDataString:_dataString];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
}

- (void)dealloc {
    _myTableView.delegate = nil;
    _myTableView.dataSource = nil;
    _myTableView = nil;
    
    _codeType = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _codeType.object.itmesList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_codeType.object.itmesList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CodeDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell setDataModel:[_codeType.object.itmesList[indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CodeDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell setDataModel:[_codeType.object.itmesList[indexPath.section] objectAtIndex:indexPath.row]];
    [cell layoutSubviews];
    [cell layoutIfNeeded];
    
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    return height + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DataModel *model =[_codeType.object.itmesList[indexPath.section] objectAtIndex:indexPath.row];
    
    if (model.clickId) {
        if ([model.clickId isEqualToString:@"check://"]) {
            
        }
        if ([model.clickId isEqualToString:@"SMSTO://"]) {
            [self displayMessagePicker];
        }
        if ([model.clickId isEqualToString:@"TEL://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dataString stringByReplacingOccurrencesOfString:@":" withString:@"://"]]];
        }
        if ([model.clickId isEqualToString:@"MAILTO://"]) {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (!mailClass) {
                [self alertWithMessage:@"当前系统版本不支持应用内发送邮件功能"];
                return;
            }
            if (![mailClass canSendMail]) {
                [self alertWithMessage:@"用户没有设置邮件账户"];
                return;
            }
            [self displayMailPicker];
        }
        if ([model.clickId isEqualToString:@"ADDRESS://"]) {
            [self AddPeople];
        }
        if ([model.clickId isEqualToString:@"Open://"]) {
            
        }
        if ([model.clickId isEqualToString:@"OpenURL://"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_dataString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -

- (void)alertWithMessage:(NSString *)message {
    if (message) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - MAIL

//调出邮件发送窗口
- (void)displayMailPicker
{
    MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: [_codeType.object.param objectForKey:@"邮箱"]];
    [mailPicker setToRecipients: toRecipients];
    
    //设置主题
    [mailPicker setSubject:[_codeType.object.param objectForKey:@"主题"]];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:[_codeType.object.param objectForKey:@"抄送"], nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:[_codeType.object.param objectForKey:@"密送"], nil];
    [mailPicker setBccRecipients:bccRecipients];
    
    // 添加一张图片
    //    UIImage *addPic = [UIImage imageNamed: @"Icon@2x.png"];
    //    NSData *imageData = UIImagePNGRepresentation(addPic);            // png
    //    [mailPicker addAttachmentData: imageData mimeType: @"" fileName: @"Icon.png"];
    
    //添加一个pdf附件
    //    NSString *file = [self fullBundlePathFromRelativePath:@"高质量C++编程指南.pdf"];
    //    NSData *pdf = [NSData dataWithContentsOfFile:file];
    //    [mailPicker addAttachmentData: pdf mimeType: @"" fileName: @"高质量C++编程指南.pdf"];
    
    NSString *emailBody = [_codeType.object.param objectForKey:@"内容"];
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg = nil;
    switch (result) {
        case MFMailComposeResultCancelled:
//            msg = @"取消编辑邮件";
            break;
        case MFMailComposeResultSaved:
            msg = @"邮件成功保存";
            break;
        case MFMailComposeResultSent:
            msg = @"邮件发送成功";
            break;
        case MFMailComposeResultFailed:
            msg = @"发送邮件失败";
            break;
        default:
            break;
    }
    [self alertWithMessage:msg];
}

#pragma mark - message

- (void)displayMessagePicker {
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    
    [messageController setRecipients:[NSArray arrayWithObjects:[_codeType.object.param objectForKey:@"收信人"], nil]];
    [messageController setSubject:[_codeType.object.param objectForKey:@"主题"]];
    [messageController setBody:[_codeType.object.param objectForKey:@"短信内容"]];
    
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MessageComposeResultSent:
            msg = @"发送成功";
            break;
        case MessageComposeResultFailed:
            msg = @"发送失败";
            break;
        case MessageComposeResultCancelled:
//            msg = @"取消发送";
            break;
        default:
            break;
    }
    [self alertWithMessage:msg];
}

#pragma mark - 加入通讯录

-(void)AddPeople
{
    //获取通讯录权限
    ABAddressBookRef ab = NULL;
    // ABAddressBookCreateWithOptions is iOS 6 and up.
    if (&ABAddressBookCreateWithOptions) {
        CFErrorRef error = nil;
        ab = ABAddressBookCreateWithOptions(NULL, &error);
        
        if (error) {
            NSLog(@"%@", error);
        }
    }
    if (ab) {
        // ABAddressBookRequestAccessWithCompletion is iOS 6 and up. 适配IOS6以上版本
        if (&ABAddressBookRequestAccessWithCompletion) {
            ABAddressBookRequestAccessWithCompletion(ab,
                                                     ^(bool granted, CFErrorRef error) {
                                                         if (granted) {
                                                             // constructInThread: will CFRelease ab.
                                                             
                                                         } else {
                                                             CFRelease(ab);
                                                             // Ignore the error
                                                         }
                                                     });
        }
    }
    
    //获取通讯录中的所有人
    //    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(ab);
    //    NSLog(@"%@" ,allPeople);
    
    
    //    //创建一条联系人记录
    ABRecordRef tmpRecord = ABPersonCreate();
    CFErrorRef error;
    BOOL tmpSuccess = NO;
    
    //Nick name
    //    CFStringRef tmpNickname = CFBridgingRetain([_codeType.object.param objectForKey:@"姓名"]);
    ABRecordSetValue(tmpRecord, kABPersonNicknameProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"姓名"]), &error);
    //    CFRelease(tmpNickname);
    
    //First name
    ABRecordSetValue(tmpRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"名字"]), &error);
    
    //Last name
    ABRecordSetValue(tmpRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"姓氏"]), &error);
    
    //phone number
    ABMutableMultiValueRef tmpMutableMultiPhones = ABMultiValueCreateMutable(kABPersonPhoneProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"电话"]), kABPersonPhoneMainLabel, NULL);
    ABMultiValueAddValueAndLabel(tmpMutableMultiPhones, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"手机号"]), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(tmpRecord, kABPersonPhoneProperty, tmpMutableMultiPhones, &error);
    CFRelease(tmpMutableMultiPhones);
    
    //Organization
    ABRecordSetValue(tmpRecord, kABPersonOrganizationProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"单位"]), &error);
    
    //Job Title
    ABRecordSetValue(tmpRecord, kABPersonJobTitleProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"职位"]), &error);
    
    //Email
    ABMutableMultiValueRef tmpMutableMultiEmail = ABMultiValueCreateMutable(kABPersonEmailProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiEmail, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"邮箱"]), kABOtherLabel, NULL);
    ABRecordSetValue(tmpRecord, kABPersonEmailProperty, tmpMutableMultiEmail, &error);
    CFRelease(tmpMutableMultiEmail);
    
    //URL
    ABMutableMultiValueRef tmpMutableMultiURL = ABMultiValueCreateMutable(kABPersonURLProperty);
    ABMultiValueAddValueAndLabel(tmpMutableMultiURL, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"网址"]), kABPersonHomePageLabel, NULL);
    ABRecordSetValue(tmpRecord, kABPersonURLProperty, tmpMutableMultiURL, &error);
    CFRelease(tmpMutableMultiURL);
    
    //address
    if ([_codeType.object.param objectForKey:@"地址"]) {
        ABMutableMultiValueRef tmpMutableMultiADR = ABMultiValueCreateMutable(kABPersonAddressProperty);
        NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
        [addressDictionary setObject:[_codeType.object.param objectForKey:@"地址"] forKey:(NSString *) kABPersonAddressStreetKey];
        ABMultiValueAddValueAndLabel(tmpMutableMultiADR, (__bridge CFTypeRef)(addressDictionary), kABHomeLabel, NULL);
        ABRecordSetValue(tmpRecord, kABPersonAddressProperty, tmpMutableMultiADR, &error);
        CFRelease(tmpMutableMultiADR);
    }
    
    //Note
    //    CFStringRef tmpNote = CFBridgingRetain([_codeType.object.param objectForKey:@"备注"]);
    ABRecordSetValue(tmpRecord, kABPersonNoteProperty, (__bridge CFTypeRef)([_codeType.object.param objectForKey:@"备注"]), &error);
    
    //保存记录
    ABAddressBookAddRecord(ab, tmpRecord, &error);
    CFRelease(tmpRecord);
    //保存数据库
    tmpSuccess = ABAddressBookSave(ab, &error);
    if (tmpSuccess) {
        [self alertWithMessage:@"添加成功"];
    }else {
        [self alertWithMessage:@"添加失败"];
    }
    //    CFRelease(ab);
}

@end
