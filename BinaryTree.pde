import controlP5.*;
ControlP5 cp5;

/* Global variables */
final color clr1 = color(28,158,46);
final int _NODE_RADIUS_ = 25;
final int _MARGIN_MIN_ = 10;
final int _MAX_NODE_ = 100;
final int _MENU_WIDTH_ = 250;

int NODE_COUNT, ROOT_VAL, TREE_HEIGHT, WIDTH_MAX, Text_File_Node_Count;
float _SCALE_ = 1;
float Theta = 0;
node[] NODE_ARRAY;
int[] MARGIN_AT_LEVEL;

/* Setup routine */
void setup(){
    println("Setup starting\n");
    //ellipseMode(CENTER);
    NODE_COUNT = 0;
    TREE_HEIGHT = 0;
    WIDTH_MAX = 0;
    Text_File_Node_Count = 0;
    NODE_ARRAY = new node[_MAX_NODE_];
    MARGIN_AT_LEVEL = new int[_MAX_NODE_];
    fullScreen();
    cp5 = new ControlP5(this);
    cp5.addSlider("Tree_Zoom").setPosition(width - _MENU_WIDTH_+ 60, 135).setSize(150,20).setRange(0,3).setValue(1);
    
    String[] nodes = split(loadStrings("BinaryTree.txt")[1], '&');
    Text_File_Node_Count = nodes.length;      
    for(int i=0; i<nodes.length; i++){
        if(nodes[i].indexOf(",") != -1){
          if(Add_Node(nodes[i]) == -1) 
            break;
        }
    }  
    //ellipseMode(CENTER);
    println("Setup completed\n");
}

/* Continuous draw routine */
void draw(){
    String[] nodes = split(loadStrings("BinaryTree.txt")[1], '&');
    Theta += 0.05;
    
    if(Text_File_Node_Count < nodes.length){
        println("\nNode(s) added\n");
        setup();
    }else if(Text_File_Node_Count > nodes.length){
        println("\nNode(s) deleted\n");
        setup();
    }     
  
    background(255);
    
    for(int j=0; j< width - _MENU_WIDTH_; j+=20){
      stroke(235);fill(235);
      line(j,0,j,height);
    }
    for(int j=0; j<height; j+=20){
      stroke(235);fill(235);
      line(0,j,width,j);
    }
    
    _SCALE_ = cp5.getController("Tree_Zoom").getValue();
    pushMatrix();        
        translate((width- _MENU_WIDTH_ - WIDTH_MAX*_SCALE_)/2, 0);
        scale(_SCALE_);
        
        int i = 0;
        for (node n:NODE_ARRAY) {
            if(i++ >= NODE_COUNT) break;  
            n.update();
            n.display();
        }
    popMatrix();
    
    Display_Notice_Board();    
}
