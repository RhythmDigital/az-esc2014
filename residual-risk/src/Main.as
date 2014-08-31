package 
{	
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.wehaverhythm.carousel.Carousel3D;
	import com.wehaverhythm.carousel.MenuItem;
	import com.wehaverhythm.slideshow.Slideshow;
	import com.wehaverhythm.starling.utils.CustomEvent;
	import com.wehaverhythm.starling.utils.StarlingUtils;
	import com.wehaverhythm.utils.IDestroyable;
	import com.wehaverhythm.utils.StarlingKeyboard;
	import com.wehaverhythm.utils.Validate;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	
	import cc.cote.feathers.softkeyboard.KeyEvent;
	import cc.cote.feathers.softkeyboard.layouts.Layout;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	
	public class Main extends Sprite implements IDestroyable
	{
		private const EMAIL_ENABLED:Boolean = true;
		private var MAX_EMAIL_CHARS:int = 40;
		
		private var stage:flash.display.Stage;
		private var mStarling:Starling;
		private var starlingStage:starling.display.Stage;
		
		private var slideshow:Slideshow;
		private var loaderHarness:LoaderMax;
		
		private var bg:Image;
		private var bgSlideshow:Image;
		
		private var currentSection:String;
		
		private var platform:String;
		public static const IPAD:String = 'ipad';
		public static const AIR:String = 'air';
		
		private var swipeText:Image;
		
		private var popupButton:Quad;
		private var popups:Object;
		
		private var currentPopup:Image;
		private var pdl1BG:Image;
		private var infoBtn:Image;
		private var requestBtn:Image;
		private var bgSlider:Sprite;
		private var requestContainer:Sprite;
		private var requestTimeline:TimelineMax;
		private var emailForm:ClipSprite;
		private var emailFormImage:Image;
		private var keyboard:StarlingKeyboard;
		private var emailText:TextField;
		private var submitBtn:Quad;
		private var emailFlashRect:Quad;
		private var thankyou:ClipSprite;
		private var requestFormClickBlock:DisplayObject;
		private var localEmailStore:TextFileWriter;
				
		public function Main()
		{
			super();		
			loaderHarness = new LoaderMax();
		}
		
		public function init(stage:flash.display.Stage):void
		{			
			this.stage = stage;
			this.starlingStage = Starling.current.stage;
			
			var loader:LoaderMax = new LoaderMax({ onComplete:onInitialLoad });
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/bg.png', {name:'bg'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/infoBtn.png', {name:'infoBtn'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/requestBtn.png', {name:'requestBtn'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/emailForm.png', {name:'emailForm'}));
			loader.append(new ImageLoader(File.applicationDirectory.url + 'assets/thankyou.png', {name:'thankyou'}));
			
			loader.load();			
			loaderHarness.insert(loader);
		}
		
		private function onInitialLoad(e:LoaderEvent):void
		{
			initBGs();			
			initSlideshow();				
		}
		
		private function initBGs():void
		{		
			bgSlider = new Sprite();
			addChild(bgSlider);
			
			bg = StarlingUtils.imageFromBitmap(LoaderMax.getContent('bg').rawContent);
			bg.touchable = true;
			bgSlider.alpha = 0;
			TweenMax.to(bgSlider, .5, {alpha:1, ease:Sine.easeIn});
			bgSlider.addChild(bg);
			
			infoBtn = StarlingUtils.imageFromBitmap(LoaderMax.getContent('infoBtn').rawContent);
			infoBtn.addEventListener(TouchEvent.TOUCH, onShowInfoClicked);
			infoBtn.x = EMAIL_ENABLED ? 244 : 1181;
			infoBtn.y = EMAIL_ENABLED ? 456 : 585;
			infoBtn.touchable = true;
			bgSlider.addChild(infoBtn);
			
			if(EMAIL_ENABLED) initRequestForm();
		}
		
		private function initRequestForm():void
		{			
			requestContainer = new Sprite();
			requestContainer.x = 1181;
			requestContainer.y = 615;
			requestContainer.touchable = true;
			bgSlider.addChild(requestContainer);
			
			requestFormClickBlock = new Quad(850,570,0xff0000);
			requestFormClickBlock.x = -525;
			requestFormClickBlock.alpha = 0;
			requestContainer.addChild(requestFormClickBlock);
			
			emailFormImage = StarlingUtils.imageFromBitmap(LoaderMax.getContent('emailForm').rawContent);
			emailForm = new ClipSprite(emailFormImage.width);
			emailForm.addChild(emailFormImage);
			emailForm.clipRect = new Rectangle(0, 0, 0, emailFormImage.height);
			emailForm.x = 120;
			emailForm.y = 27;
			emailForm.touchable = true;
			requestContainer.addChild(emailForm);
			
			var thankyouImage:Image = StarlingUtils.imageFromBitmap(LoaderMax.getContent('thankyou').rawContent);
			thankyou = new ClipSprite(thankyouImage.width);
			thankyou.addChild(thankyouImage);
			thankyou.clipRect = new Rectangle(0, 0, 0, thankyouImage.height);
			thankyou.x = 120;
			thankyou.y = 27;
			requestContainer.addChild(thankyou);
			
			submitBtn = new Quad(100,35, 0xff0000);
			submitBtn.alpha = 0;
			submitBtn.x = 150;
			submitBtn.y = 150;
			submitBtn.touchable = true;
			submitBtn.addEventListener(TouchEvent.TOUCH, onSubmitClicked);
			emailForm.addChild(submitBtn);
			
			requestBtn = StarlingUtils.imageFromBitmap(LoaderMax.getContent('requestBtn').rawContent);
			requestBtn.addEventListener(TouchEvent.TOUCH, onRequestInfoClicked);
			requestBtn.touchable = true;
			requestContainer.addChild(requestBtn);
			
			keyboard = new StarlingKeyboard(Starling.current.stage, 800, 250);
			keyboard.x = -500;
			keyboard.y = 340;
			keyboard.alpha = 0;
			keyboard.visible = false;
			keyboard.keyboard.addEventListener(KeyEvent.KEY_UP, onKeyUp);
			requestContainer.addChild(keyboard);
			
			requestTimeline = new TimelineMax();
			requestTimeline.insert(TweenMax.to(requestContainer, .4, {y:requestContainer.y-250, ease:Sine.easeOut}));
			requestTimeline.insert(TweenMax.to(emailForm, .35, {x:-440, ease:Sine.easeInOut}), 0);
			requestTimeline.insert(TweenMax.to(emailForm.clipRect, .35, {width:emailForm.originalWidth, ease:Sine.easeInOut}), 0);
			requestTimeline.insert(TweenMax.to(keyboard, .35, {y:280, autoAlpha:1, ease:Sine.easeOut}), .3);
			//requestTimeline.append(TweenMax.to(keyboard.clipRect, .35, {height:emailForm.originalHeight, ease:Sine.easeInOut}), 0);
			requestTimeline.pause(0);
			
			emailFlashRect = new Quad(363, 36, 0xff0000);
			emailFlashRect.x = 27;
			emailFlashRect.y = 63;
			emailFlashRect.alpha = 0;
			emailForm.addChild(emailFlashRect);
			
			emailText = new TextField(340, 36, "Email address", "Helvetica Neue", 18, 0x000000, false);
			//emailText.border = true;
			emailText.autoScale = true;
			emailText.x = 37;
			emailText.y = 64;
			emailForm.addChild(emailText);
			
			
			// email text file
			localEmailStore = new TextFileWriter();			
		}
		
		private function onKeyUp(e:KeyEvent):void
		{
			if(e.char != null) {
				if(emailText.text.length < MAX_EMAIL_CHARS) emailText.text += e.char;
			}
			else if(e.charCode == 8) emailText.text = emailText.text.substr(0,emailText.text.length-1);
			else trace(e.charCode);
		}
		
		public function onSubmitClicked(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				if(Validate.isValidEmail(emailText.text))
				{
					trace("Submitting email");
					localEmailStore.writeLine(emailText.text);
					submitEmail(emailText.text);
					showThankYou(.5);
					closeRequestForm();
				} else {
					// flash error.
					emailFlashRect.alpha = 0;
					TweenMax.killTweensOf(emailFlashRect);
					TweenMax.to(emailFlashRect, .2, {alpha:.4, repeat:1, yoyo:true, ease:Sine.easeOut, overwrite:2});
				}				
			}
		}
		
		private function showThankYou(delay:Number = 2):void
		{
			TweenMax.to(thankyou, .35, {delay:delay, repeat:1, yoyo:true, repeatDelay:2, x:-440, ease:Sine.easeInOut})
			TweenMax.to(thankyou.clipRect, .35, {delay:delay, repeat:1, yoyo:true, repeatDelay:2, width:thankyou.originalWidth, ease:Sine.easeInOut});
		}
		
		private function submitEmail(emailAddress:String):void
		{
			var emailURI:String = encodeURIComponent(emailAddress);
			
			var l:URLLoader = new URLLoader();
			l.addEventListener(IOErrorEvent.IO_ERROR, onEmailIOError);
			l.addEventListener(flash.events.Event.COMPLETE, onEmailSubmitSuccess);
			
			var url:String = "https://wehaverhythm.com/clients/wrg/az-esc2014/residualrisk/register/submit?email="+emailURI;
			trace("Submitting: " + url);
			
			var req:URLRequest = new URLRequest(url);
			req.method = URLRequestMethod.GET;
			l.load(req);
		}
		
		protected function onEmailSubmitSuccess(e:flash.events.Event):void
		{
			trace("Email submitted successfully");
		}
		
		protected function onEmailIOError(e:IOErrorEvent):void
		{
			trace("Email error");
		}
		
		private function onRequestInfoClicked(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				openRequestForm();
			}
		}
		
		public function openRequestForm():void
		{
			requestTimeline.play();
			requestBtn.removeEventListener(TouchEvent.TOUCH, onRequestInfoClicked);
			emailText.text = "";
			bg.addEventListener(TouchEvent.TOUCH, onTapStageDuringRegister);
		}
		
		protected function onTapStageDuringRegister(e:TouchEvent):void
		{
			if(e.touches[0].phase == TouchPhase.BEGAN)
			{
				closeRequestForm();
			}
		}
		
		public function closeRequestForm():void
		{
			requestBtn.addEventListener(TouchEvent.TOUCH, onRequestInfoClicked);
			requestTimeline.reverse();
			emailText.text = "";
			bg.removeEventListener(TouchEvent.TOUCH, onTapStageDuringRegister);
		}
		
		private function onShowInfoClicked(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				TweenMax.to(bgSlider, .8, {y:-1080, ease:Sine.easeInOut});
				
				addChild(slideshow);
				slideshow.show();				
				if(EMAIL_ENABLED) closeRequestForm();
			}
		}

		private function initSlideshow():void
		{
			slideshow = new Slideshow();
			slideshow.addEventListener(Slideshow.GO_HOME, onGoHome);			
			slideshow.init();
		}
		
		private function onGoHome(e:CustomEvent):void
		{
			reset();
		}
		
		public function reset():void
		{
			TweenMax.to(bgSlider, .8, {y:0, ease:Sine.easeInOut});
			slideshow.hide();
			if(EMAIL_ENABLED) closeRequestForm();
		}
		
		public function destroy():void
		{
			TweenMax.killTweensOf(this);
			TweenMax.killTweensOf(bgSlideshow);
			
			loaderHarness.dispose(true);
			loaderHarness = null;
			
			stage = null;
			starlingStage = null;			
			
			removeChild(slideshow);
			slideshow.removeEventListener(Slideshow.GO_HOME, onGoHome);
			slideshow.destroy();
			slideshow = null;
		}
	}
}

