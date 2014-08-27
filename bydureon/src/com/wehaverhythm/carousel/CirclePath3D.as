package com.wehaverhythm.carousel
{
	import com.greensock.motionPaths.CirclePath2D;
	import com.greensock.motionPaths.PathFollower;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	public class CirclePath3D extends CirclePath2D
	{
		private var lift:Number;
		
		
		public function CirclePath3D(x:Number, y:Number, radius:Number, $lift:Number = 0)
		{
			this.lift = $lift;
			super(x, y, radius);
		}
		
		/** @inheritDoc**/
		override public function update(event:Event=null):void {
			var angle:Number, px:Number, py:Number;
			var m:Matrix = this.transform.matrix;
			var a:Number = m.a, b:Number = m.b, c:Number = m.c, d:Number = m.d, tx:Number = m.tx, ty:Number = m.ty;
			var f:PathFollower = _rootFollower;
			while (f) {
				angle = f.cachedProgress * Math.PI * 2;
				px = Math.cos(angle) * _radius;
				py = Math.sin(angle) * _radius;
				f.target.x = px * a + py * c + tx;
				f.target.z = px * b + py * d + ty;
				f.target.y = f.target.z * lift;
				if (f.autoRotate) {
					angle += Math.PI / 2;
					px = Math.cos(angle) * _radius;
					py = Math.sin(angle) * _radius;
					f.target.rotation = Math.atan2(px * m.b + py * m.d, px * m.a + py * m.c) * _RAD2DEG + f.rotationOffset;
				}
				
				f = f.cachedNext;
			}
			if (_redrawLine) {
				var g:Graphics = this.graphics;
				g.clear();
				g.lineStyle(_thickness, _color, _lineAlpha, _pixelHinting, _scaleMode, _caps, _joints, _miterLimit);
				g.drawCircle(0, 0, _radius);
				_redrawLine = false;
			}
		}
		
		/** @inheritDoc **/
		override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean=false, rotationOffset:Number=0):void {
			var angle:Number = progress * Math.PI * 2;
			var m:Matrix = this.transform.matrix;
			var px:Number = Math.cos(angle) * _radius;
			var py:Number = Math.sin(angle) * _radius;
			target.x = px * m.a + py * m.c + m.tx;
			target.z = px * m.b + py * m.d + m.ty;
			target.y = target.z * lift;
			
			if (autoRotate) {
				angle += Math.PI / 2;
				px = Math.cos(angle) * _radius;
				py = Math.sin(angle) * _radius;
				target.rotationY = Math.atan2(px * m.b + py * m.d, px * m.a + py * m.c) * _RAD2DEG + rotationOffset;
			}
		}
	}
}