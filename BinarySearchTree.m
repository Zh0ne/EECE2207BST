classdef BinarySearchTree
    properties
        root
    end

    methods
        function obj = BinarySearchTree()
            % Constructor for initializing an empty tree
            obj.root = [];
        end

        function obj = add(obj, node_value)
            % Adds a new node with the given value to the BST
            newNode = struct('data', node_value, 'left', [], 'right', []);
            if isempty(obj.root)
                obj.root = newNode;
            else
                obj.root = obj.insertNode(obj.root, newNode);
            end
        end

        function node = insertNode(obj, current, newNode)
            % Recursive helper to insert nodes correctly in the BST
            if isempty(current)
                node = newNode;
            elseif newNode.data < current.data
                current.left = obj.insertNode(current.left, newNode); % Recursive call
                node = current;
            else
                current.right = obj.insertNode(current.right, newNode); % Recursive call
                node = current;
            end
        end

        function [obj, deletedValue] = delete(obj, target)
            % Deletes the node with the specified target value
            [obj.root, deletedValue] = obj.deleteNode(obj.root, target);
        end

        function [node, deletedValue] = deleteNode(obj, current, target)
            % Recursive function to delete a node
            if isempty(current)
                node = [];
                deletedValue = [];
                return;
            end

            if target < current.data
                [current.left, deletedValue] = obj.deleteNode(current.left, target);
                node = current;
            elseif target > current.data
                [current.right, deletedValue] = obj.deleteNode(current.right, target);
                node = current;
            else
                % Node with two children
                if ~isempty(current.left) && ~isempty(current.right)
                    [successorValue, current.right] = obj.deleteSuccessor(current.right);
                    current.data = successorValue;
                    node = current;
                    deletedValue = target;
                elseif ~isempty(current.left) % Only left child
                    node = current.left;
                    deletedValue = current.data;
                elseif ~isempty(current.right) % Only right child
                    node = current.right;
                    deletedValue = current.data;
                else % Leaf node
                    node = [];
                    deletedValue = current.data;
                end
            end
        end

        function [value, node] = deletePredecessor(obj, node)
            % Deletes the in-order predecessor node
            if isempty(node.right)
                value = node.data;
                node = node.left;
            else
                [value, node.right] = obj.deletePredecessor(node.right);
            end
        end

        function [value, node] = deleteSuccessor(obj, node)
            % Deletes the in-order successor node
            if isempty(node.left)
                value = node.data;
                node = node.right;
            else
                [value, node.left] = obj.deleteSuccessor(node.left);
            end
        end

        function result = find(obj, target)
            % Searches for a value in the tree using recursion
            result = obj.findHelper(obj.root, target);
        end

        function result = findHelper(obj, node, target)
            % Helper function for finding a node recursively
            if isempty(node)
                result = [];
            elseif node.data == target
                result = node.data;
            elseif target < node.data
                result = obj.findHelper(node.left, target); % Recursive call
            else
                result = obj.findHelper(node.right, target); % Recursive call
            end
        end

        function result = findIterative(obj, target)
            % Searches for a value iteratively
            current = obj.root;
            while ~isempty(current)
                if current.data == target
                    result = current.data;
                    return;
                elseif target < current.data
                    current = current.left;
                else
                    current = current.right;
                end
            end
            result = [];
        end

        function preOrderTraversal(obj)
            % Prints pre-order traversal of the tree
            obj.preOrderTraversalHelper(obj.root);
            fprintf('\n');
        end

        function preOrderTraversalHelper(~, node)
            if ~isempty(node)
                fprintf('%d ', node.data);
                preOrderTraversalHelper(node.left);
                preOrderTraversalHelper(node.right);
            end
        end

        function inOrderTraversal(obj)
            % Prints in-order traversal of the tree
            obj.inOrderTraversalHelper(obj.root);
            fprintf('\n');
        end

        function inOrderTraversalHelper(~, node)
            if ~isempty(node)
                inOrderTraversalHelper(node.left);
                fprintf('%d ', node.data);
                inOrderTraversalHelper(node.right);
            end
        end

        function str = strHelper(obj, node, indent)
            % Helper function for printing the tree structure
            if isempty(node)
                str = [indent, 'None\n'];
            else
                str = sprintf('%s%d\n', indent, node.data);
                str = [str, obj.strHelper(node.left, [indent, '  '])];
                str = [str, obj.strHelper(node.right, [indent, '  '])];
            end
        end

        function display(obj)
            % Displays the tree structure
            fprintf(obj.strHelper(obj.root, ''));
        end
    end
end
