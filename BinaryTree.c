/*
 *  BinaryTree.cpp
 *
 *  Created on	: Aug 25, 2015
 *  Author		: Adesh Shah
 */
#include "BinaryTree.h"

using namespace std;

BinaryTree :: BinaryTree() {
    MAX_NODE = 100;
    FILE_NAME = "Nodes.txt";
    ROOT = NULL;
}
BinaryTree :: ~BinaryTree() {
    Destroy_Tree();
}

/* Public Methods*/
void    BinaryTree :: Insert_Node(int _Val) {
	if(ROOT == NULL){
	    ROOT 		= new Node;
	    ROOT->Val  	= _Val;
	    ROOT->Left 	= NULL;
	    ROOT->Right	= NULL;
	}
	else
		Insert_Node(_Val, ROOT);
}
void    BinaryTree :: Delete_Node(int _Val) {
    Node** _Node 	= NULL;
    Node** _Parent 	= NULL;
    if(Search(_Val, _Node, _Parent) == true )
    	Delete_Node(_Val, *_Node, *_Parent);
}
int 	BinaryTree :: Node_Count() {
	if(ROOT == NULL)
		return 0;
	return Node_Count(ROOT);
}
int     BinaryTree :: Tree_Height() {
    return Tree_Height(ROOT);
}
bool    BinaryTree :: Search(int _Val, Node** _Node, Node** _Parent) {
	if(ROOT->Val == _Val){
		cout << _Node << endl;
		*_Node = ROOT;
		cout << "ROOT value found" << endl;
		return true;
    }
    *_Node = Search(ROOT, _Val, _Parent);
    if(*_Node == NULL)
        return false;
    else
        return true;
}
void    BinaryTree :: Destroy_Tree() {
    Destroy_Tree(ROOT);
}
void    BinaryTree :: Balance_Tree() {
    Balance_Tree(ROOT);
}
void    BinaryTree :: Merge_Tree(Node* _Root) {
    Merge_Tree(ROOT, _Root);
}
void    BinaryTree :: Print_Tree(int Option) {
	if(Option == 1)
		Print_Tree_To_File(ROOT, FILE_NAME);
	else if(Option == 2)
		Print_Nodes(ROOT,ROOT);
	else if(Option == 3)
		Print_InOrder(ROOT);
	else if(Option == 4)
		Print_PreOrder(ROOT);
	else if(Option == 5)
		Print_PostOrder(ROOT);

}
void	BinaryTree :: Print_Menu(){
	cout 	<< endl << "--- Program Menu: ---" 		<< endl
			<< "01. Insert a node" 		 			<< endl
			<< "02. Delete a node" 					<< endl
			<< "03. Search a node"					<< endl
			<< "04. Get Node count"					<< endl
			<< "05. Get Tree height"				<< endl
			<< "06. Balance Tree (coming soon)" 	<< endl
			<< "07. Rotate Tree (coming soon)"		<< endl
			<< "08. Merge Trees (coming soon)"		<< endl
			<< "09. Print Tree to File (for GUI)" 	<< endl
			<< "10. Print 'Parent-Node' pair" 		<< endl
			<< "11. Print InOrder Tree" 			<< endl
			<< "12. Print PreOrder Tree" 			<< endl
			<< "13. Print PostOrder Tree" 			<< endl
			<< " 0. Exit" << endl 					<< endl;
}
/* Private Methods*/
void   	BinaryTree :: Insert_Node(int _Val, Node* _Node) {
	if( _Val < _Node->Val ){
		if( _Node->Left != NULL )
			Insert_Node(_Val, _Node->Left);
		else{
			_Node->Left				= new Node;
			_Node->Left->Val		= _Val;
			_Node->Left->Left		= NULL;    //Sets the left child of the child node to null
			_Node->Left->Right		= NULL;   //Sets the right child of the child node to null
		}
	}
	else if( _Val > _Node->Val ){
		if( _Node->Right!=NULL )
			Insert_Node( _Val, _Node->Right );
		else{
			_Node->Right			= new Node;
			_Node->Right->Val		= _Val;
			_Node->Right->Left		= NULL;  //Sets the left child of the child node to null
			_Node->Right->Right		= NULL; //Sets the right child of the child node to null
		}
	}
}
bool    BinaryTree :: Delete_Node(int _Val ,Node* _Node, Node* _Parent){
    /* If Tree == empty -> do nothing */
    if (ROOT == NULL)
        return false;

    /* CASE: 1 -> No child ->  Free(_Parent->child) */
    if( _Node->Left == NULL && _Node->Right == NULL ){
        if ( _Parent->Right == _Node )
            _Parent->Right = NULL;
        else if ( _Parent->Left == _Node )
            _Parent->Left = NULL;

        delete _Node;
        return true;
    }

    /* CASE:2 -> 1 child (_Left or _Right) ->  _Parent->child = _Parent->child->child ->  Free(_Parent->child) */
    else if( _Node->Left == NULL && _Node->Right != NULL ){
        if ( _Parent->Left == _Node )
            _Parent->Left = _Node->Right;
        else if ( _Parent->Right == _Node )
            _Parent->Right = _Node->Right;

        delete _Node;
        return true;
    }
    else if( _Node->Left != NULL && _Node->Right == NULL ){
        if ( _Parent->Left == _Node )
            _Parent->Left = _Node->Left;
        else if( _Parent->Right == _Node )
            _Parent->Right = _Node->Left;

        delete _Node;
        return true;
    }
    /* CASE:3 -> 2 Children ->  Min = minimum value from _Left dynasty ->  _Parent->child->val = Min ->  Free(&Min) */
    if( _Node->Left != NULL && _Node->Right != NULL ){
        if( _Node->Right->Left != NULL ) {               /* Right child has children  */
            Node* Left_Node 		= _Node->Right->Left;
            Node* Left_Node_Parent  = _Node->Right;

            while( Left_Node->Left != NULL ){
                Left_Node_Parent    = Left_Node;
                Left_Node           = Left_Node->Left;
            }
            _Node->Val = Left_Node->Val;
            delete Left_Node;
            Left_Node_Parent->Left  = NULL;
            return true;
        }
        else if( _Node->Right->Left == NULL ) {           /* Right child has no child  */
            Node* Temp      = _Node->Right;
            _Node->Val      = Temp->Val;
            _Node->Right    = Temp->Right;
            delete Temp;
            return true;
        }
    }

    return false;
}
int     BinaryTree :: Node_Count(Node* _Node) {
	int Count = 1;
	if (_Node == NULL)
	    return 0;
	else
	{
		Count += Node_Count(_Node->Left);
		Count += Node_Count(_Node->Right);
	    return Count;
	}
}
int     BinaryTree :: Tree_Height(Node* _Node) {
    if( _Node == NULL )
        return -1;
    else
        return max(Tree_Height( _Node->Left ), Tree_Height( _Node->Right )) + 1;
}
Node*   BinaryTree :: Search(Node* _Node, int _Val, Node** _Parent) {
    if( _Node != NULL ){
        if( _Node->Val == _Val)
            return _Node;
        else if( _Node->Val > _Val ){
            *_Parent = _Node;
            return Search( _Node->Left, _Val, _Parent );
        }
        else if( _Node->Val < _Val ){
            *_Parent = _Node;
            return Search( _Node->Right, _Val, _Parent );
        }
    }
    else
    	return NULL;
}
void    BinaryTree :: Merge_Tree(Node* _Root1, Node* _Root2) {

}
void    BinaryTree :: Destroy_Tree(Node* _Node) {
    if( _Node != NULL ){
    	cout << "Deleting node: " << _Node->Val << endl;
        Destroy_Tree( _Node->Left );
        Destroy_Tree( _Node->Right );
        delete _Node;
        _Node = NULL;
    }
}
void    BinaryTree :: Balance_Tree(Node* _Node) {

}
void    BinaryTree :: Print_Tree_To_File(Node* _Node, char* _File_Name) {
	ofstream File;
	File.open( _File_Name );
	File << Tree_Height() << endl;
	File.close();
	Print_Nodes_To_File(_Node, _Node, _File_Name);
}
void 	BinaryTree :: Print_Nodes_To_File(Node* _Parent, Node* _Node, char* _File_Name) {
	ofstream File;
	File.open( _File_Name, ios::app );
	File << _Parent->Val << "," <<  _Node->Val << "+";
	File.close();

	if( _Node->Left != NULL )
		Print_Nodes_To_File( _Node, _Node->Left, _File_Name );
	if( _Node->Right != NULL )
		Print_Nodes_To_File( _Node, _Node->Right, _File_Name );
}
void 	BinaryTree :: Print_InOrder(Node* _Node){
    if ( _Node != NULL ) {
    	Print_InOrder( _Node->Left );
        cout << _Node->Val << " ";
        Print_InOrder( _Node->Right );
    }
}
void 	BinaryTree :: Print_PreOrder(Node* _Node){
    if ( _Node != NULL ) {
       cout << _Node->Val << " ";
       Print_PreOrder( _Node->Left );
       Print_PreOrder( _Node->Right );
    }
}
void 	BinaryTree :: Print_PostOrder(Node* _Node){
    if ( _Node != NULL ) {
    	Print_PostOrder( _Node->Left );
    	Print_PostOrder( _Node->Right );
        cout << _Node->Val << " ";
    }
}
void 	BinaryTree :: Print_Nodes(Node* _Parent, Node* _Node){
	cout << "(" << _Parent->Val << "," <<  _Node->Val << ") ";
	if( _Node->Left != NULL )
		Print_Nodes( _Node, _Node->Left );
	if( _Node->Right != NULL )
		Print_Nodes( _Node, _Node->Right );
}
