//
// Copyright (c) 2017 Related Code - http://relatedcode.com
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "RCMessagesView.h"
#import "RCMessagesStatusCell.h"
#import "RCMessagesTextCell.h"
#import "RCMessagesEmojiCell.h"
#import "RCMessagesPictureCell.h"
#import "RCMessagesVideoCell.h"
#import "RCMessagesAudioCell.h"
#import "RCMessagesLocationCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RCMessagesView()
{
	BOOL initialized;
	CGPoint centerView;
	CGFloat heightView;

	NSTimer *timerAudio;
	NSDate *dateAudioStart;
	CGPoint pointAudioStart;
	AVAudioRecorder *audioRecorder;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RCMessagesView

@synthesize viewTitle, labelTitle1, labelTitle2, buttonTitle;
@synthesize viewLoadEarlier;
@synthesize viewTypingIndicator;
@synthesize viewInput, buttonInputAttach, buttonInputAudio, buttonInputSend, textInput, viewInputAudio, labelInputAudio;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (id)init
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	self = [self initWithNibName:@"RCMessagesView" bundle:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	return self;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLoad];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.navigationItem.titleView = viewTitle;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self.tableView registerClass:[RCMessagesStatusCell class] forCellReuseIdentifier:@"RCMessagesStatusCell"];
	[self.tableView registerClass:[RCMessagesTextCell class] forCellReuseIdentifier:@"RCMessagesTextCell"];
	[self.tableView registerClass:[RCMessagesEmojiCell class] forCellReuseIdentifier:@"RCMessagesEmojiCell"];
	[self.tableView registerClass:[RCMessagesPictureCell class] forCellReuseIdentifier:@"RCMessagesPictureCell"];
	[self.tableView registerClass:[RCMessagesVideoCell class] forCellReuseIdentifier:@"RCMessagesVideoCell"];
	[self.tableView registerClass:[RCMessagesAudioCell class] forCellReuseIdentifier:@"RCMessagesAudioCell"];
	[self.tableView registerClass:[RCMessagesLocationCell class] forCellReuseIdentifier:@"RCMessagesLocationCell"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.tableHeaderView = viewLoadEarlier;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardDidHideNotification object:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(audioRecorderGesture:)];
	gesture.minimumPressDuration = 0;
	gesture.cancelsTouchesInView = NO;
	[buttonInputAudio addGestureRecognizer:gesture];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	viewInputAudio.hidden = YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self inputPanelInit];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLayoutSubviews
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidLayoutSubviews];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	centerView = self.view.center;
	heightView = self.view.frame.size.height;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self inputPanelUpdate];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillAppear:animated];
	[self dismissKeyboard];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidAppear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewDidAppear:animated];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (initialized == NO)
	{
		initialized = YES;
		[self scrollToBottom:YES];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------
	centerView = self.view.center;
	heightView = self.view.frame.size.height;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)viewWillDisappear:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[super viewWillDisappear:animated];
	[self dismissKeyboard];
}

#pragma mark - Load earlier methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)loadEarlierShow:(BOOL)show
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	viewLoadEarlier.hidden = !show;
	CGRect frame = viewLoadEarlier.frame;
	frame.size.height = show ? 50 : 0;
	viewLoadEarlier.frame = frame;
	[self.tableView reloadData];
}

#pragma mark - Message methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (RCMessage *)rcmessage:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - Avatar methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)avatarInitials:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UIImage *)avatarImage:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - Header, Footer methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textCellHeader:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textBubbleHeader:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textBubbleFooter:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSString *)textCellFooter:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

#pragma mark - Menu controller methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSArray *)menuItems:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)canBecomeFirstResponder
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return YES;
}

#pragma mark - Typing indicator methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorShow:(BOOL)show animated:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if (show)
	{
		self.tableView.tableFooterView = viewTypingIndicator;
		[self scrollToBottom:animated];
	}
	else
	{
		[UIView animateWithDuration:(animated ? 0.25 : 0) animations:^{
			self.tableView.tableFooterView = nil;
		}];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)typingIndicatorUpdate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - Keyboard methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)keyboardShow:(NSNotification *)notification
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSDictionary *info = [notification userInfo];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect keyboard = [[info valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat heightKeyboard = keyboard.size.height;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.view.center = CGPointMake(centerView.x, centerView.y - heightKeyboard);
	} completion:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[[UIMenuController sharedMenuController] setMenuItems:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)keyboardHide:(NSNotification *)notification
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSDictionary *info = [notification userInfo];
	NSTimeInterval duration = [[info valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
		self.view.center = centerView;
	} completion:nil];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)dismissKeyboard
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self.view endEditing:YES];
}

#pragma mark - Input panel methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)inputPanelInit
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	viewInput.backgroundColor = [RCMessages inputViewBackColor];
	textInput.backgroundColor = [RCMessages inputTextBackColor];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textInput.font = [RCMessages inputFont];
	textInput.textColor = [RCMessages inputTextTextColor];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textInput.textContainer.lineFragmentPadding = 0;
	textInput.textContainerInset = [RCMessages inputInset];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textInput.layer.borderColor = [RCMessages inputBorderColor];
	textInput.layer.borderWidth = [RCMessages inputBorderWidth];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textInput.layer.cornerRadius = [RCMessages inputRadius];
	textInput.clipsToBounds = YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)inputPanelUpdate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGFloat widthText = textInput.frame.size.width, heightText;
	CGSize sizeText = [textInput sizeThatFits:CGSizeMake(widthText, MAXFLOAT)];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	heightText = fmaxf([RCMessages inputTextHeightMin], sizeText.height);
	heightText = fminf([RCMessages inputTextHeightMax], heightText);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat heightInput = heightText + ([RCMessages inputViewHeightMin] - [RCMessages inputTextHeightMin]);
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, heightView - heightInput);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect frameViewInput = viewInput.frame;
	frameViewInput.origin.y = heightView - heightInput;
	frameViewInput.size.height = heightInput;
	viewInput.frame = frameViewInput;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[viewInput layoutIfNeeded];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect frameAttach = buttonInputAttach.frame;
	frameAttach.origin.y = heightInput - frameAttach.size.height;
	buttonInputAttach.frame = frameAttach;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect frameTextInput = textInput.frame;
	frameTextInput.size.height = heightText;
	textInput.frame = frameTextInput;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect frameAudio = buttonInputAudio.frame;
	frameAudio.origin.y = heightInput - frameAudio.size.height;
	buttonInputAudio.frame = frameAudio;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect frameSend = buttonInputSend.frame;
	frameSend.origin.y = heightInput - frameSend.size.height;
	buttonInputSend.frame = frameSend;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	buttonInputAudio.hidden = ([textInput.text length] != 0);
	buttonInputSend.hidden = ([textInput.text length] == 0);
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGPoint offset = CGPointMake(0, sizeText.height - heightText);
	[textInput setContentOffset:offset animated:NO];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self scrollToBottom:NO];
}

#pragma mark - User actions (title)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionTitle:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self actionTitle];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTitle
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - User actions (load earlier)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionLoadEarlier:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self actionLoadEarlier];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionLoadEarlier
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - User actions (cell tap)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTapCell:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - User actions (bubble tap)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTapBubble:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - User actions (avatar tap)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionTapAvatar:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

#pragma mark - User actions (input panel)

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionInputAttach:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self actionAttachMessage];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (IBAction)actionInputSend:(id)sender
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([textInput.text length] != 0)
	{
		[self actionSendMessage:textInput.text];
		[self dismissKeyboard];
		textInput.text = nil;
		[self inputPanelUpdate];
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionAttachMessage
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSendAudio:(NSString *)path
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSendMessage:(NSString *)text
//-------------------------------------------------------------------------------------------------------------------------------------------------
{

}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)actionSelectMember
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	
}

#pragma mark - UIScrollViewDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self dismissKeyboard];
}

#pragma mark - Table view data source

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 1;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_STATUS)	return [RCMessagesStatusCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_TEXT)		return [RCMessagesTextCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_EMOJI)	return [RCMessagesEmojiCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_PICTURE)	return [RCMessagesPictureCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_VIDEO)	return [RCMessagesVideoCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_AUDIO)	return [RCMessagesAudioCell height:indexPath messagesView:self];
	if (rcmessage.type == RC_TYPE_LOCATION)	return [RCMessagesLocationCell height:indexPath messagesView:self];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return 0;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (rcmessage.type == RC_TYPE_STATUS)	return [self tableView:tableView cellStatusForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_TEXT)		return [self tableView:tableView cellTextForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_EMOJI)	return [self tableView:tableView cellEmojiForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_PICTURE)	return [self tableView:tableView cellPictureForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_VIDEO)	return [self tableView:tableView cellVideoForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_AUDIO)	return [self tableView:tableView cellAudioForRowAtIndexPath:indexPath];
	if (rcmessage.type == RC_TYPE_LOCATION)	return [self tableView:tableView cellLocationForRowAtIndexPath:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return nil;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellStatusForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesStatusCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellTextForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesTextCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellEmojiForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesEmojiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesEmojiCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellPictureForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesPictureCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellVideoForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesVideoCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellAudioForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesAudioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesAudioCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellLocationForRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessagesLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RCMessagesLocationCell" forIndexPath:indexPath];
	[cell bindData:indexPath messagesView:self];
	return cell;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [self rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return (rcmessage.type != RC_TYPE_STATUS);
}

#pragma mark - Helper methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)scrollToBottom:(BOOL)animated
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([self.tableView numberOfRowsInSection:0] > 0)
	{
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([self.tableView numberOfRowsInSection:0] - 1) inSection:0];
		[self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:animated];
	}
}

#pragma mark - UITextViewDelegate

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	if ([text isEqualToString:@"@"])
		[self actionSelectMember];
	return YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)textViewDidChange:(UITextView *)textView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[self inputPanelUpdate];
	[self typingIndicatorUpdate];
}

#pragma mark - Audio recorder methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)audioRecorderGesture:(UILongPressGestureRecognizer *)gestureRecognizer
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	switch (gestureRecognizer.state)
	{
		case UIGestureRecognizerStateBegan:
		{
			pointAudioStart = [gestureRecognizer locationInView:self.view];
			[self audioRecorderInit];
			[self audioRecorderStart];
			break;
		}
		case UIGestureRecognizerStateChanged:
		{
			break;
		}
		case UIGestureRecognizerStateEnded:
		{
			CGPoint pointAudioStop = [gestureRecognizer locationInView:self.view];
			CGFloat distanceAudio = sqrtf(powf(pointAudioStop.x - pointAudioStart.x, 2) + pow(pointAudioStop.y - pointAudioStart.y, 2));
			[self audioRecorderStop:(distanceAudio < 50)];
			break;
		}
		case UIGestureRecognizerStatePossible:
		case UIGestureRecognizerStateCancelled:
		case UIGestureRecognizerStateFailed:
			break;
	}
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)audioRecorderInit
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSString *dir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
	NSString *path = [dir stringByAppendingPathComponent:@"audiorecorder.m4a"];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	AVAudioSession *session = [AVAudioSession sharedInstance];
	[session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
	settings[AVFormatIDKey] = @(kAudioFormatMPEG4AAC);
	settings[AVSampleRateKey] = @(44100);
	settings[AVNumberOfChannelsKey] = @(2);
	//---------------------------------------------------------------------------------------------------------------------------------------------
	audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settings error:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	audioRecorder.meteringEnabled = YES;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[audioRecorder prepareToRecord];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)audioRecorderStart
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[audioRecorder record];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	dateAudioStart = [NSDate date];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	timerAudio = [NSTimer scheduledTimerWithTimeInterval:0.07 target:self selector:@selector(audioRecorderUpdate) userInfo:nil repeats:YES];
	[[NSRunLoop mainRunLoop] addTimer:timerAudio forMode:NSRunLoopCommonModes];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[self audioRecorderUpdate];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	viewInputAudio.hidden = NO;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)audioRecorderStop:(BOOL)sending
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	[audioRecorder stop];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[timerAudio invalidate]; timerAudio = nil;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	if ((sending) && ([[NSDate date] timeIntervalSinceDate:dateAudioStart] >= 1))
	{
		[self actionSendAudio:audioRecorder.url.path];
	}
	else [audioRecorder deleteRecording];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	viewInputAudio.hidden = YES;
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)audioRecorderUpdate
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:dateAudioStart];
	int millisec = (int) (interval * 100) % 100;
	int seconds = (int) interval % 60;
	int minutes = (int) interval / 60;
	labelInputAudio.text = [NSString stringWithFormat:@"%01d:%02d,%02d", minutes, seconds, millisec];
}

@end
