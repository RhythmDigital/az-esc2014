package com.astrazeneca.video
{
	import com.wehaverhythm.utils.IDestroyable;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.geom.Rectangle;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import org.bytearray.video.SimpleStageVideo;
	
	import starling.core.Starling;
	
	
	public class StarlingStageVideoManager extends EventDispatcher implements IDestroyable
	{
		private static var instance:StarlingStageVideoManager;
		private var stage:Stage;
	
		public static const VIDEO_KILLED:String = 'VIDEO_KILLED';
		
		private var nc:NetConnection;
		private var ns:NetStream;
		
		private var simpleStageVideo:SimpleStageVideo;
		private var rect:Rectangle;
		
		private var playerReady:Boolean;
		private var videoPath:String;
		
		public var controls:StageVideoControls;
		private var closeBTN:CloseBTN;
		private var iPad:Boolean;
		
		
		public function StarlingStageVideoManager(pvt:SingletonEnforcer)
		{
			playerReady = false;
		}
		
		public static function getInstance():StarlingStageVideoManager
		{
			if ( instance == null ) instance = new StarlingStageVideoManager( new SingletonEnforcer() );
			return instance;
		}
		
		public function init(stage:Stage, rect:Rectangle=null, iPad:Boolean=false, controlsBelowVideo:Boolean=false):void
		{
			if (!playerReady)
			{
				this.stage = stage;
				this.iPad = iPad;
			
				trace('stage.stageWidth:', stage.stageWidth);
				
				if (iPad && stage.stageWidth > 1024 && rect != null)
				{
					rect.x = rect.x*2;
					rect.y = rect.y*2;
					rect.width = rect.width*2;
					rect.height = rect.height*2;
				}
				
				this.rect = rect;
				
				nc = new NetConnection();
				nc.connect(null);
				
				ns = new NetStream(nc);
				ns.client = this;
				
				simpleStageVideo = new SimpleStageVideo(stage, rect);
				simpleStageVideo.attachNetStream(ns);
				
				controls = new StageVideoControls();
				controls.belowVideo = controlsBelowVideo;
				
				closeBTN = new CloseBTN();
				
				if (rect == null)
				{
					closeBTN.x = stage.stageWidth - 55;
					closeBTN.y = 30;
				}
				else {
					closeBTN.x = rect.x + rect.width;
					closeBTN.y = rect.y;
				}
				
				
				if (stage.stageWidth > 1024) closeBTN.scaleX = closeBTN.scaleY = 1.3;				
				closeBTN.addEventListener(MouseEvent.MOUSE_DOWN, killVideo);
			}
		}
		
		public function onXMPData(obj:Object):void
		{
			// DUMMY
		}
		
		public function play(path:String):void
		{			
			stage.addChild(simpleStageVideo);
			stage.addChild(controls);
			stage.addChild(closeBTN);
			
			Starling.current.stage3D.visible = false;
			Starling.current.stage.touchable = false;
			
			ns.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			trace('playerReady?', playerReady);
			
			if (playerReady) ns.play(path);
			else {
				videoPath = path;
				simpleStageVideo.addEventListener(Event.INIT, onSimpleStageVideoInit);
			}
		}
		
		public function killVideo(e:MouseEvent=null):void
		{
			ns.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			ns.pause();
			ns.close();
			
			if (stage.contains(simpleStageVideo)) stage.removeChild(simpleStageVideo);	
			if (stage.contains(closeBTN)) stage.removeChild(closeBTN);
			if (stage.contains(controls)) stage.removeChild(controls);
			
			Starling.current.stage3D.visible = true;
			Starling.current.stage.touchable = true;
			
			dispatchEvent(new Event(VIDEO_KILLED));
		}
		
		public function onMetaData(metadata:Object):void
		{
			trace('got metadata!');
			controls.init(rect, simpleStageVideo.fillScreen, ns, metadata.duration, stage, iPad);
		}	
		
		protected function onSimpleStageVideoInit(e:Event):void
		{
			simpleStageVideo.removeEventListener(Event.INIT, onSimpleStageVideoInit);
			playerReady = true;
			
			if (videoPath != null) play(videoPath);
		}
		
		protected function onNetStatus(e:NetStatusEvent):void
		{
			if (e.info.code == 'NetStream.Play.Stop')
			{			
				killVideo();
			}
		}
		
		override public function toString():String
		{
			return 'StarlingStageVideoManager ::';
		}
		
		public function destroy():void
		{
			killVideo();
			
			playerReady = false;
			ns = null;
			nc = null;
			
			stage = null;
			rect = null;
			
			simpleStageVideo.removeEventListener(Event.INIT, onSimpleStageVideoInit);
			simpleStageVideo = null;
			
			controls.destroy();
			controls = null;
			
			closeBTN.removeEventListener(MouseEvent.MOUSE_DOWN, killVideo);
			closeBTN = null;
		}
		
		public function onPlayStatus(info:Object=null):void {}
		
	}
}

internal class SingletonEnforcer{};