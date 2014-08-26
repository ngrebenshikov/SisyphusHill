import bpy  
import math
from mathutils import Vector
  
  
def MakePolyLine(objname, curvename, cList):  
    curvedata = bpy.data.curves.new(name=curvename, type='CURVE')  
    curvedata.dimensions = '3D'  
  
    objectdata = bpy.data.objects.new(objname, curvedata)  
    objectdata.location = (0,0,0) #object origin  
    bpy.context.scene.objects.link(objectdata)  
  
    polyline = curvedata.splines.new('NURBS')  
    polyline.points.add(len(cList)-1)  
    for num in range(len(cList)):  
        polyline.points[num].co = (cList[num])+(w,)  
  
    polyline.order_u = len(polyline.points)-1
    polyline.use_endpoint_u = True
    

def ArchymedSpiral(a, phi):
    return {"x": a*phi*math.cos(phi), "y": a*phi*math.sin(phi)}


def Circle(r, phi):
    return {"x": r*math.cos(phi), "y": r*math.sin(phi)}
    

def CreateMesh(name, a1, b1, c1, d1, a2, b2, c2, d2):
    verts = [a1, b1, c1, d1, a2, b2, c2, d2]
    faces = [(0,1,2,3), (4,5,6,7), (4,0,1,5), (3,2,6,7), (0,3,7,4), (1,5,6,2)]
    
    #print(verts)

    #create mesh and object
    mesh = bpy.data.meshes.new(name)
    object = bpy.data.objects.new(name,mesh)
 
    #set mesh location
    object.location = bpy.context.scene.cursor_location
    bpy.context.scene.objects.link(object)
 
    #create mesh from python data
    mesh.from_pydata(verts,[],faces)
    mesh.update(calc_edges=True)
    
    bpy.context.scene.objects.active = object
    bpy.ops.object.mode_set(mode='EDIT')
    # select all faces
    bpy.ops.mesh.select_all(action='SELECT')
    # recalculate outside normals 
    bpy.ops.mesh.normals_make_consistent(inside=False)
    # go object mode again
    bpy.ops.object.editmode_toggle()
    
a = 0.07
phi = 5
d = 0.5
dd = 0.0;
r = 0.3
z = 5

a1 = None
b1 = None
c1 = None
d1 = None

a2 = None
b2 = None
c2 = None
d2 = None

while (phi < 40):
    a1 = a2
    b1 = b2
    c1 = c2
    d1 = d2

    circle = Circle(r, phi)
    spiral = ArchymedSpiral(a, phi)

    a2 = (circle["x"], circle["y"], 0)
    b2 = (circle["x"], circle["y"], z)
    c2 = (spiral["x"], spiral["y"], z+dd)
    d2 = (spiral["x"], spiral["y"], 0)
    
    if (not (a1 is None)):
        CreateMesh("mesh"+str(phi), a1, b1, c1, d1, a2, b2, c2, d2)
        
    phi += 0.1
    
    if phi > 12.56:    
        z -= 0.004
    if dd < d:
        dd += 0.0005