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
                println("-------------------------------------");  
                println("Val.update(): "+Value);
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
                println("Nth: "+Nth+" Value: "+Value+" Parent_Value: "+Parent_Value);
                if(Value < Parent_Value)  
                    IamNth = (Nth-1)*2 + 1;
                else if(Value > Parent_Value)
                    IamNth = (Nth-1)*2 + 2;
                println("Parent_frm_left: "+Nth + ", Iam_from_left: "+IamNth);
                X_Pos = Margin + _NODE_RADIUS_ + 2*(Margin + _NODE_RADIUS_)*(IamNth-1);
                Y_Pos = Parent_y_pos + 3*_NODE_RADIUS_;
                println("XPOS: "+X_Pos+ ", YPOS:"+Y_Pos);
           }
           //println("Node_Pos_Updated: ");
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

        if(overCircle(X_Pos, Y_Pos)){
            stroke(clr1);
            fill(255);
            ellipse(X_Pos, Y_Pos, _NODE_RADIUS_*2, _NODE_RADIUS_*2);
        }
        else{
            stroke(clr1);   fill(clr1);
            ellipse(X_Pos, Y_Pos, _NODE_RADIUS_*2, _NODE_RADIUS_*2);
            stroke(255);            fill(255);
            ellipse(X_Pos, Y_Pos, (_NODE_RADIUS_-10)*2, (_NODE_RADIUS_-10)*2);
            line(  X_Pos-_NODE_RADIUS_*cos(Theta), Y_Pos-_NODE_RADIUS_*sin(Theta), X_Pos+_NODE_RADIUS_*cos(Theta), Y_Pos+_NODE_RADIUS_*sin(Theta)  );       
        }
        
        fill(clr1);
        textSize(15);
        text(Value, X_Pos-5, Y_Pos+5); 
    }
}
