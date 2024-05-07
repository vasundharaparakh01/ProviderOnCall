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

#import "RCMessagesCell.h"

//-------------------------------------------------------------------------------------------------------------------------------------------------
@interface RCMessagesEmojiCell : RCMessagesCell
//-------------------------------------------------------------------------------------------------------------------------------------------------

@property (strong, nonatomic) UITextView *textView;

- (void)bindData:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView;

+ (CGFloat)height:(NSIndexPath *)indexPath messagesView:(RCMessagesView *)messagesView;

@end
