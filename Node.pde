import controlP5.*;
ControlP5 cp5;

/* Global variables */
color clr1 = color(26,52,77);

String Input_Box_Text;

final int _NODE_RADIUS_ = 25;
final int _MARGIN_MIN_ = 10;
final int _MAX_NODE_ = 100;
final int _MENU_WIDTH_ = 250;

int NODE_COUNT = 0,
    ROOT_VAL,
    TREE_HEIGHT = 0,
    WIDTH_MAX = 0;
float _SCALE_ = 1;

node[] NODE_ARRAY;
int[] MARGIN_AT_LEVEL = new int[_MAX_NODE_];


/* Setup routine */
void setup(){
    size(1000,650);
    frameRate(25);
    
    cp5 = new ControlP5(this);
    cp5.addTextfield("Insert_PreOrderTraversal").setPosition(width - _MENU_WIDTH_ + 5, 20).setSize(_MENU_WIDTH_ - 10, 40).setAutoClear(true);
    cp5.addBang("Create_Tree").setPosition(width - _MENU_WIDTH_ + 5, 80).setSize(_MENU_WIDTH_ - 10, 40);  
    cp5.addSlider("Tree_Zoom").setPosition(width - _MENU_WIDTH_+ 70, 285).setSize(80,20).setRange(0,3).setValue(1); //<>//
    NODE_ARRAY = new node[_MAX_NODE_];
   
    Add_Node("5,0");
    Add_Node("8,5");
    Add_Node("3,5");
    Add_Node("1,3");
    Add_Node("4,3");
    Add_Node("6,8");
    Add_Node("7,6");
    Add_Node("10,8");
    Add_Node("2,1");
    Add_Node("-2,1");
    Add_Node("9,10");
    Add_Node("15,10");
    
    println("-------------------------");
    //Add_Node("10,8");
    //Add_Node("7,8");
}

/* Continuous draw routine */
void draw(){
    background(255);
    _SCALE_ = cp5.getController("Tree_Zoom").getValue();
    int i = 0;
    pushMatrix();
    translate((width-_MENU_WIDTH_-WIDTH_MAX*_SCALE_)/2, 0);
    scale(_SCALE_);
    for (node n:NODE_ARRAY) {
        if(i++ >= NODE_COUNT) break;  
        n.update();
        n.display();
    }
    popMatrix();
    Display_Notice_Board();
}

/* submit function for input box */
void Submit() {
  Input_Box_Text = cp5.get(Textfield.class,"Insert_PreOrderTraversal").getText();
  println("Create_Tree: " + Input_Box_Text);
  Create_Tree(Input_Box_Text);
}



/* Supporting functions */
/* for negative response return -1 not 0 */

/* Create tree from pre-order-traversed nodes using Add_Node() */
void Create_Tree(String _Pre_Order_Traversal){

}


/* Input node info ---> 2,3 : nodeVal,parentVal */ 
int Add_Node(String _Node_Info){
    String[] Temp = split(_Node_Info, ',');
    int _Parent_Value = int(Temp[1]),
        _Val = int(Temp[0]);
    
    println("Add_Node: "+ _Node_Info);
    if(NODE_COUNT == 0){
        ROOT_VAL = _Val; 
        NODE_ARRAY[NODE_COUNT++] = new node(_Val, 0, 0, 1); 
        Recalculate_Margin_At_Each_Level();
        return 1;
    }
    else if(NODE_COUNT != 0){
        if(If_Node_Exist(_Parent_Value) == 1 && If_Node_Exist(_Val) == -1){
            int TempLevel = Get_Level(_Parent_Value) + 1; 

            int[] TempIfChildren = Children_Exist(_Parent_Value);
            if(_Val < _Parent_Value && TempIfChildren[0] == 0){
                NODE_ARRAY[NODE_COUNT++] = new node(_Val, _Parent_Value, TempLevel, 0);
                Edit_Children_Exist(_Parent_Value, 0, _Val);               
            }
            else if(_Val > _Parent_Value && TempIfChildren[1] == 0){
                NODE_ARRAY[NODE_COUNT++] = new node(_Val, _Parent_Value, TempLevel, 0); 
                Edit_Children_Exist(_Parent_Value, 1, _Val);               
            }
            Recalculate_Margin_At_Each_Level();
            return 1;
        }
    }
    return -1;
}

/* Recalculate tree height */
int Tree_Height(int _Value){
    if(If_Node_Exist(_Value) == -1)
        return -1;
    else{
        int[] TempIfChildren = Children_Exist(_Value);
        int[] ChildrenValue = Get_Children_Value(_Value);
        
        if(TempIfChildren[0] == 0 && TempIfChildren[1] == 0)
            return 1;
        else if(TempIfChildren[0] == 1 && TempIfChildren[1] == 0){
            return Tree_Height(ChildrenValue[0]) + 1;
        }
        else if(TempIfChildren[0] == 0 && TempIfChildren[1] == 1){
            return Tree_Height(ChildrenValue[1]) + 1;
        }
        else if(TempIfChildren[0] == 1 && TempIfChildren[1] == 1){
            return max(Tree_Height(ChildrenValue[0]), Tree_Height(ChildrenValue[0])) + 1;
        }
    }
    return -1;
}


/* Recalculate margin at each level */
void Recalculate_Margin_At_Each_Level(){
    TREE_HEIGHT = Tree_Height(ROOT_VAL) -1;
    WIDTH_MAX = int((_MARGIN_MIN_ + _NODE_RADIUS_) * pow(2, TREE_HEIGHT + 1));
    for(int i=0; i<_MAX_NODE_; i++){
        if(i<TREE_HEIGHT)
            MARGIN_AT_LEVEL[i] = int((WIDTH_MAX/(pow(2,i+1))) - _NODE_RADIUS_);
        else if(i == TREE_HEIGHT)
            MARGIN_AT_LEVEL[i] = _MARGIN_MIN_;
        else
        MARGIN_AT_LEVEL[i] = 0;
    }
}


/* Edit children exist variables of node object */
void Edit_Children_Exist(int _Value, int _Left_Or_Right, int _Child_Val){
    int i = 0;
    for (node n:NODE_ARRAY) {
        if(i++ >= NODE_COUNT) break;
        if(n.Value == _Value){
            if(_Left_Or_Right == 0){
                n.Left_Child_Exist = 1;
                n.Left_Child_Value = _Child_Val;
            }    
            else{    
                n.Right_Child_Exist = 1;
                n.Right_Child_Value = _Child_Val;
            }    
        }
    } 
}

/* Check if node exists */
int If_Node_Exist(int _Value){
    int i = 0;
    for (node n:NODE_ARRAY) {
        if(i++ >= NODE_COUNT) break;
        if(n.Value == _Value)
            return 1;
    }
    return -1;
}

/* Check if children exist */
int[] Children_Exist(int _Value){
    int Temp[] = {0,0};
    int i = 0;
    for (node n:NODE_ARRAY){
        if(i++ >= NODE_COUNT) break;
        if(n.Value == _Value){
          Temp[0] = n.Left_Child_Exist;        
          Temp[1] = n.Right_Child_Exist;
        return Temp;
        }
    }
    return Temp;
}

/* Get Children Value */
int[] Get_Children_Value(int _Value){
    int Temp[] = {0,0};
    int i = 0;
    for (node n:NODE_ARRAY){
        if(i++ >= NODE_COUNT) break;
        if(n.Value == _Value){
            Temp[0] = n.Left_Child_Value;        
            Temp[1] = n.Right_Child_Value;
        return Temp;
        }
    }
    return Temp;
}

/* Get node position from its ID */
int[] Get_Pos(int _Value){
    int Pos[] = {-1,-1};
    int i = 0;
    for (node n:NODE_ARRAY){
      if(i++ >= NODE_COUNT) break;
      if(n.Value == _Value){
        Pos[0] = n.X_Pos;
        Pos[1] = n.Y_Pos;
        return Pos;
      }
    }
    return Pos; 
}

/* Get node level from its ID */
int Get_Level(int _Value){
    int i = 0;
    for (node n:NODE_ARRAY) {
        if(i++ >= NODE_COUNT) break;
        if(n.Value == _Value)
            return n.Level;
    }
    return -1; 
}

/* Class defination */
class node{
    int Value, Parent_Value, Level,
        Margin, X_Pos, Y_Pos, 
        Parent_x_pos, Parent_y_pos,        
        Left_Child_Exist, Right_Child_Exist,
        Left_Child_Value, Right_Child_Value,
        Is_Root_Node,
        Temp_Count;
        
    node(int _Value, int _Parent_Value, int _Level, int _Is_Root_Node){
        Value = _Value;
        Parent_Value = _Parent_Value;
        Level = _Level;        
        Margin = 0;
        X_Pos = 0; 
        Y_Pos = _MARGIN_MIN_ + _NODE_RADIUS_;     
        Parent_x_pos = 0; 
        Parent_y_pos = 0;
        Left_Child_Exist = 0;  
        Right_Child_Exist = 0;        
        Left_Child_Value = 0;
        Right_Child_Value = 0;
        Is_Root_Node = _Is_Root_Node;
        Temp_Count = 0;
    }
    
    void update(){    
        if(Is_Root_Node == 1)  //if not root node  
            X_Pos = int(WIDTH_MAX/2);
        else if(Is_Root_Node == 0){  //if not root node  
            int Pos[] = Get_Pos(Parent_Value);
            if(Temp_Count != NODE_COUNT){
                println("-------------------------");  
                println("val.update: "+Value);
                Temp_Count = NODE_COUNT;
                Parent_x_pos = Pos[0];
                Parent_y_pos = Pos[1];            
                
                int Margin_Prev_Level = MARGIN_AT_LEVEL[Level-1],
                    Margin = MARGIN_AT_LEVEL[Level],
                    Nth = 1;
                println("Margin_Prev_Level: "+Margin_Prev_Level+", My_Margin: "+Margin);
                /* calculate 'Nth' parent node from left at same level --> super logic */
                int temp = Margin_Prev_Level + _NODE_RADIUS_;
                while(temp < Parent_x_pos){
                    temp += 2*(Margin_Prev_Level + _NODE_RADIUS_);  
                    Nth++;    
                }
                
                int IamNth = -1;
                //println("Nth: "+Nth+" Value: "+Value+" Parent_Value: "+Parent_Value);
                if(Value < Parent_Value)  
                    IamNth = (Nth-1)*2 + 1;
                else if(Value > Parent_Value)
                    IamNth = (Nth-1)*2 + 2;
                println("Parent_frm_left: "+Nth + ", Iam_from_left: "+IamNth);
                X_Pos = Margin + _NODE_RADIUS_ + 2*(Margin + _NODE_RADIUS_)*(IamNth-1);
                Y_Pos = Parent_y_pos + 3*_NODE_RADIUS_;
                println("XPOS: "+X_Pos+ ", YPOS:"+Y_Pos);
           }
           //println("Node_Pos_Updated");
        }  
    }
    
    void display(){ 
        if(Left_Child_Exist == 1){
            int Pos[] = Get_Pos(Left_Child_Value);
            stroke(clr1);
            line(X_Pos, Y_Pos, Pos[0], Pos[1]); 
        }
        
        if(Right_Child_Exist == 1){
            int pos[] = Get_Pos(Right_Child_Value);
            stroke(clr1);
            line(X_Pos, Y_Pos, pos[0], pos[1]);
        }
        stroke(clr1);
        fill(255);
        ellipse(X_Pos, Y_Pos, _NODE_RADIUS_*2, _NODE_RADIUS_*2);
        fill(clr1);
        textSize(15);
        text(Value, X_Pos-5, Y_Pos+5); 
    }
}

void Display_Notice_Board(){
    int X_Pos = width - _MENU_WIDTH_,
      Y_Pos = 0,
      i = 1;
    
    stroke(165,165,165);
    fill(165,165,165);
    rect(X_Pos, Y_Pos, _MENU_WIDTH_, height);
    
    i++;
    i++;
    i++;
    i++;
    
    stroke(255);
    line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));  
    
    fill(255);
    textSize(15);
    text("NODE_RADIUS: "+_NODE_RADIUS_  , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("MARGIN_MIN: "+_MARGIN_MIN_    , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("MAX_NODE: "+_MAX_NODE_        , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("NODE_COUNT: "+NODE_COUNT      , width - _MENU_WIDTH_+15, 15*(2*i++));    
    text("ZOOM: "                       , width - _MENU_WIDTH_+15, 15*(2*i++));
    
    stroke(255);
    line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));
    
    fill(255);
    text("ROOT_VAL: "+ROOT_VAL          , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("TREE_HEIGHT: "+TREE_HEIGHT    , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("WIDTH_MAX: "+WIDTH_MAX        , width - _MENU_WIDTH_+15, 15*(2*i++));
    
    stroke(255);
    line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));    
}
