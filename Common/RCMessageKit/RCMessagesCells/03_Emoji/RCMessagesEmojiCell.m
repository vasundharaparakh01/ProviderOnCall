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

#import "RCMessagesEmojiCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RCMessagesEmojiCell()
{
	NSIndexPath *indexPath;
	RCMessagesView *messagesView;
}
@end
//-------------------------------------------------------------------------------------------------------------------------------------------------

@implementation RCMessagesEmojiCell

@synthesize textView;

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)bindData:(NSIndexPath *)indexPath_ messagesView:(RCMessagesView *)messagesView_
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	indexPath = indexPath_;
	messagesView = messagesView_;
	//---------------------------------------------------------------------------------------------------------------------------------------------
	RCMessage *rcmessage = [messagesView rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	[super bindData:indexPath messagesView:messagesView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	self.viewBubble.backgroundColor = rcmessage.incoming ? [RCMessages emojiBubbleColorIncoming] : [RCMessages emojiBubbleColorOutgoing];
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	if (textView == nil)
	{
		textView = [[UITextView alloc] init];
		textView.font = [RCMessages emojiFont];
		textView.editable = NO;
		textView.selectable = NO;
		textView.scrollEnabled = NO;
		textView.userInteractionEnabled = NO;
		textView.backgroundColor = [UIColor clearColor];
		textView.textContainer.lineFragmentPadding = 0;
		textView.textContainerInset = [RCMessages emojiInset];
		[self.viewBubble addSubview:textView];
	}
	//---------------------------------------------------------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------------------------------------------------------
	textView.text = rcmessage.text;
	//---------------------------------------------------------------------------------------------------------------------------------------------
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
- (void)layoutSubviews
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGSize size = [RCMessagesEmojiCell size:indexPath messagesView:messagesView];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	[super layoutSubviews:size];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	textView.frame = CGRectMake(0, 0, size.width, size.height);
}

#pragma mark - Size methods

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)height:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	CGSize size = [self size:indexPath messagesView:messagesView];
	return [RCMessagesCell height:indexPath messagesView:messagesView size:size];
}

//-------------------------------------------------------------------------------------------------------------------------------------------------
+ (CGSize)size:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView
//-------------------------------------------------------------------------------------------------------------------------------------------------
{
	RCMessage *rcmessage = [messagesView rcmessage:indexPath];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat maxwidth = (0.6 * SCREEN_WIDTH) - [RCMessages emojiInsetLeft] - [RCMessages emojiInsetRight];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGRect rect = [rcmessage.text boundingRectWithSize:CGSizeMake(maxwidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin
											attributes:@{NSFontAttributeName:[RCMessages emojiFont]} context:nil];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	CGFloat width = rect.size.width + [RCMessages emojiInsetLeft] + [RCMessages emojiInsetRight];
	CGFloat height = rect.size.height + [RCMessages emojiInsetTop] + [RCMessages emojiInsetBottom];
	//---------------------------------------------------------------------------------------------------------------------------------------------
	return CGSizeMake(fmaxf(width, [RCMessages emojiBubbleWidthMin]), fmaxf(height, [RCMessages emojiBubbleHeightMin]));
}

@end
