The main part is the shader entitled "Wobble Noise" This is the shader that does the wobbling and has controls.

There is a material in the Materials folder with this shader attached.

I've written some scripts called Line Generator and Tube Generator which generate a bunch of Line Prefabs (found in the prefab folder) but if you attach the material to anything it will wobble it so you can lay out your own lines and/or tubes. It will work on any model or 3D primitive. To change from lines to tubes in the example just disable the tube renderer in the Line prefab and enable the line renderer component.