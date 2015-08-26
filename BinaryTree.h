/*
 *  BinaryTree.h
 *
 *  Created on	: Aug 25, 2015
 *  Author		: Adesh Shah
 */
#ifndef BINARYTREECPP_H
#define BINARYTREECPP_H

#include <fstream>
#include <iostream>
#include <algorithm>

typedef struct _Node
{
  int Val;
  _Node *Left,
  		*Right;
} Node;

class BinaryTree
{
    public:
        BinaryTree();
        ~BinaryTree();

        /* Methods */
        void    Insert_Node(int);
        void    Delete_Node(int);
        int 	Node_Count();
        int     Tree_Height();
        bool    Search(int, Node**, Node**);
        void    Destroy_Tree();
        void    Balance_Tree();
        void    Merge_Tree(Node*);
        void    Print_Tree(int);
        void	Print_Menu();

    private:
        /* Variables */
        int 	MAX_NODE;
        char* 	FILE_NAME;
        Node* 	ROOT;

        /* Methods */
        void    Insert_Node(int, Node*);
        bool    Delete_Node(int, Node*, Node*);
        int 	Node_Count(Node*);
        int     Tree_Height(Node*);
        Node*   Search(Node*, int, Node**);
        void    Merge_Tree(Node*, Node*);
        void    Destroy_Tree(Node*);
        void    Balance_Tree(Node*);
        /* Tree PRINTing operations */
        void 	Print_Nodes_To_File(Node*,Node*,char*);
        void 	Print_Tree_To_File(Node*,char*);
        void 	Print_InOrder(Node*);
        void 	Print_PreOrder(Node*);
        void 	Print_PostOrder(Node*);
        void	Print_Nodes(Node*, Node*);
};

#endif // BINARYTREECPP_H
