package arm;
import kha.Image;
import iron.Scene;
import iron.Trait;
import iron.math.Quat;
import iron.object.Object;
import iron.object.CameraObject;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat;
import armory.renderpath.RenderToTexture;
import armory.renderpath.RenderPathCreator;
class MyTrait extends Trait {
	var q: Quat = new Quat(0,0,0.01,1);
	var o: Object = Scene.active.getChild("Suzanne");
	var c = cast(Scene.active.getChild("Camera.001"),CameraObject);
	public function new() {
		super();
		notifyOnInit(function() {
			if (c.renderTarget == null) c.renderTarget = Image.createRenderTarget(256,256,TextureFormat.RGBA32,DepthStencilFormat.NoDepthAndStencil);
		});
		notifyOnUpdate(function() {
			q.normalize();
			o.transform.rot.mult(q);
			o.transform.buildMatrix();
		});
		notifyOnRender(function(g:kha.graphics4.Graphics) {
			var ac = Scene.active.camera;
			Scene.active.camera = c;
			c.renderFrame(g);
			Scene.active.camera = ac;
		});
		notifyOnRender2D(function(g:kha.graphics2.Graphics) {
			if (RenderPathCreator.finalTarget == null) return;
			var i = RenderPathCreator.finalTarget.image;
			g.drawScaledImage(i,0,0,i.width/2,i.height/2);
			g = null;
		});
	}
}