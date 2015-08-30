/* Supporting functions (for -ve response return -1 not 0) */

/* Input node info ---> 2,3 : nodeVal,parentVal */ 
int Add_Node(String _Node_Info){
    String[] Temp = split(_Node_Info, ',');
    int _Parent_Value = int(Temp[1]),
        _Val = int(Temp[0]);
    
    println("Add_Node: "+ _Node_Info);
    if(NODE_COUNT == 0){
        ROOT_VAL = _Val;
        println("ROOT value updated!");
        NODE_ARRAY[NODE_COUNT++] = new node(_Val, 0, 0, 1); 
        Recalculate_Margin_At_Each_Level();
        println("Node added\n");
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
            println("Node added\n");
            return 1;
        }
        else
            println("Existance error -> IF_Parent:"+If_Node_Exist(_Parent_Value)+", IF_Node:"+If_Node_Exist(_Val)+" Count: "+NODE_COUNT+"\n");      
    }
    println("Node not added! \n NO MORE NODE WILL BE LOADED!");
    return -1;
}

/* Recalculate tree height */
int Tree_Height(int _Value){
    
    return Integer.parseInt(loadStrings("BinaryTree.txt")[0]);
    
    /*
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
    */
}

/* Recalculate margin at each level */
void Recalculate_Margin_At_Each_Level(){
    TREE_HEIGHT = Tree_Height(ROOT_VAL);
    println("TREE_HEIGHT recalculated: "+TREE_HEIGHT);
    
    WIDTH_MAX = int((_MARGIN_MIN_ + _NODE_RADIUS_) * pow(2, TREE_HEIGHT + 1));
    println("WIDTH_MAX recalculated: "+WIDTH_MAX);
    
    for(int i=0; i<_MAX_NODE_; i++){
        if(i<TREE_HEIGHT)
            MARGIN_AT_LEVEL[i] = int((WIDTH_MAX/(pow(2,i+1))) - _NODE_RADIUS_);
        else if(i == TREE_HEIGHT)
            MARGIN_AT_LEVEL[i] = _MARGIN_MIN_;
        else
        MARGIN_AT_LEVEL[i] = 0;
    }
    println("Margins recalculated!");
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

/* Display Menu and Notice */
void Display_Notice_Board(){
    int X_Pos = width - _MENU_WIDTH_,
      Y_Pos = 0,
      i = 1;
    
    stroke(255);
    fill(255);
    rect(X_Pos, Y_Pos, _MENU_WIDTH_, height);
    stroke(clr1);
    line(width - _MENU_WIDTH_, 0,width - _MENU_WIDTH_,height);  
    
    stroke(255,0,0);
    fill(255,0,0);
    rect(width-20, 0, 20, 20);
    
    //stroke(clr1);
    //line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));  
    
    fill(clr1);
    textSize(11);
    text("NODE_RADIUS: "+_NODE_RADIUS_  , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("MARGIN_MIN: "+_MARGIN_MIN_    , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("MAX_NODE: "+_MAX_NODE_        , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("NODE_COUNT: "+NODE_COUNT      , width - _MENU_WIDTH_+15, 15*(2*i++));    
    text("ZOOM: "                       , width - _MENU_WIDTH_+15, 15*(2*i++));
    
    stroke(clr1);
    line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));
    
    fill(clr1);
    text("ROOT_VAL: "+ROOT_VAL          , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("TREE_HEIGHT: "+TREE_HEIGHT    , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("WIDTH_MAX: "+WIDTH_MAX        , width - _MENU_WIDTH_+15, 15*(2*i++));
    text("TREE_HEIGHT: "+loadStrings("BinaryTree.txt")[0], width - _MENU_WIDTH_+15, 15*(2*i++));


    stroke(clr1);
    line(width - _MENU_WIDTH_, 15*(2*i),width,15*(2*i++));    
}

boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

boolean overCircle(int x, int y){
  //println("x: "+mouseX+" y: "+mouseY+ " R: "+_NODE_RADIUS_*_SCALE_);
  float temp = (width - _MENU_WIDTH_ - WIDTH_MAX*_SCALE_)/2;
  if (pow((temp + x*_SCALE_ - mouseX),2) + pow((y*_SCALE_ - mouseY),2) >= pow(_NODE_RADIUS_*_SCALE_,2))
        return true;
    else
        return false;
}

/* If clicked close button -> exit */
void mousePressed() {
  if (overRect(width-20, 0, 20, 20))    
    exit();
}
