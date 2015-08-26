/*
 *  Main.cpp
 *
 *  Created on	: Aug 25, 2015
 *  Author		: Adesh Shah
 */

#include <iostream>
#include "BinaryTree.h"

using namespace std;

int main(int argc, char** argv) {
	cout << "--- Binary Tree Program ---" << endl << endl << "Have " << argc << " arguments:" << endl;
    for (int i = 0; i < argc; ++i)
        cout << (i+1) << ". " << argv[i] << endl;
    cout << endl;

    int Option = 1,
		Temp_Val;

	BinaryTree Tree1;

	while( Option != 0 ){
		Tree1.Print_Menu();
		cin >> Option;

		switch(Option){
			case 1:{
				cout << "Enter a value" << endl;
				cin >> Temp_Val;
				Tree1.Insert_Node(Temp_Val);
				cout << "Node added!" << endl;
				break;
			} case 2:{
				cout << "Enter the value" << endl;
				cin >> Temp_Val;
				Tree1.Delete_Node(Temp_Val);
				cout << "Node deleted" << endl;
				break;
			} case 3:{
				cout << "Enter the value" << endl;
				cin >> Temp_Val;
				Node *Node_Address = NULL, *Node_Parent_Address = NULL;
				bool Found = Tree1.Search( Temp_Val, &Node_Address, &Node_Parent_Address );
				cout << "Found " << Found << " at " << Node_Address << endl;
				break;
			} case 4:{
				cout << "Node count: " << Tree1.Node_Count() << endl;
				break;
			} case 5:{
				cout << "Tree height: "<< Tree1.Tree_Height() << endl;
				break;
			} case 6:{
				Tree1.Balance_Tree();
				cout << "Tree balanced!" << endl;
				break;
			} case 7:{
				cout << "'Rotate' Coming soon!" << endl;
				break;
			}
			case 8:{
				cout << "'Merge' Coming soon!" << endl;
				break;
			} case 9:{
				cout << "Tree to file (for GUI): " << endl;
				Tree1.Print_Tree(1);
				cout << endl << "Tree printed!" << endl;
				break;
			} case 10:{
				cout << "Parent-Node Pair Tree: " << endl;
				Tree1.Print_Tree(2);
				cout << endl << "Tree printed!" << endl;
				break;
			} case 11:{
				cout << "InOrder Tree: " << endl;
				Tree1.Print_Tree(3);
				cout << endl << "Tree printed!" << endl;
				break;
			} case 12:{
				cout << "PreOrder Tree: " << endl;
				Tree1.Print_Tree(4);
				cout << endl << "Tree printed!" << endl;
				break;
			} case 13:{
				cout << "PostOrder Tree: " << endl;
				Tree1.Print_Tree(5);
				cout << endl << "Tree printed!" << endl;
				break;
			} case 0:{
				cout << "Program exiting!" << endl;
				break;
			} default:{
				cout << "Invalid option!" << endl;
				break;
			}
		}
	}
	return 0;
}
