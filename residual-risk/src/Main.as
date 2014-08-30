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
			bgSlider.alpha = 0;
			TweenMax.to(bgSlider, .5, {alpha:1, ease:Sine.easeIn});
			bgSlider.addChild(bg);
			
			infoBtn = StarlingUtils.imageFromBitmap(LoaderMax.getContent('infoBtn').rawContent);
			infoBtn.addEventListener(TouchEvent.TOUCH, onShowInfoClicked);
			infoBtn.x = 244;
			infoBtn.y = 456;
			infoBtn.touchable = true;
			bgSlider.addChild(infoBtn);
			
			initRequestForm();
		}
		
		private function initRequestForm():void
		{
			requestContainer = new Sprite();
			requestContainer.x = 1181;
			requestContainer.y = 615;
			requestContainer.touchable = true;
			bgSlider.addChild(requestContainer);
			
			emailFormImage = StarlingUtils.imageFromBitmap(LoaderMax.getContent('emailForm').rawContent);
			
			emailForm = new ClipSprite(emailFormImage.width);
			emailForm.addChild(emailFormImage);
			emailForm.clipRect = new Rectangle(0, 0, 0, emailFormImage.height);
			emailForm.x = 120;
			emailForm.y = 27;
			emailForm.touchable = true;
			requestContainer.addChild(emailForm);
			
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
			
			emailText = new TextField(340, 36, "Email address", "Helvetica Neue", 18, 0x000000, false);
			//emailText.border = true;
			emailText.autoScale = true;
			emailText.x = 37;
			emailText.y = 64;
			emailForm.addChild(emailText);
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
			if (e.touches[0].phase == TouchPhase.BEGAN &&
				Validate.isValidEmail(emailText.text))
			{
				trace("Submitting email");
				submitEmail(emailText.text);
				closeRequestForm();
			}
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
				// animate up
				openRequestForm();
				
				
				// show input field
				
				// show keyboard
			}
		}
		
		public function openRequestForm():void
		{
			requestTimeline.play();
			requestBtn.removeEventListener(TouchEvent.TOUCH, onRequestInfoClicked);
			emailText.text = "";
		}
		
		public function closeRequestForm():void
		{
			requestBtn.addEventListener(TouchEvent.TOUCH, onRequestInfoClicked);
			requestTimeline.reverse();
			emailText.text = "";
		}
		
		private function onShowInfoClicked(e:TouchEvent):void
		{
			if (e.touches[0].phase == TouchPhase.BEGAN)
			{
				TweenMax.to(bgSlider, .8, {y:-1080, ease:Sine.easeInOut});
				
				addChild(slideshow);
				slideshow.show();				
				closeRequestForm();
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

