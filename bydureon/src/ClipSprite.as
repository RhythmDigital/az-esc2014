package
{
	import starling.display.Sprite;
	
	public class ClipSprite extends Sprite
	{
		public var originalWidth:Number;
		
		
		public function ClipSprite(originalWidth:Number)
		{
			super();
			
			this.originalWidth = originalWidth;
		}
	}
}