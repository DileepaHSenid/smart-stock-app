import 'package:flutter/material.dart';
import 'package:project/components/appbar.dart';
import 'package:project/controllers/user_controller.dart';
import 'package:project/ui/Users/adduser.dart';
import 'package:project/ui/Users/edituser.dart';
import 'package:project/ui/suppliers/editsupplier.dart';

class Users extends StatelessWidget {
  const Users({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Users'),
      body: UserManagementPage(),
    );
  }
}

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  _UserManagementPage createState() => _UserManagementPage();
}

class _UserManagementPage extends State<UserManagementPage> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  bool isLoading = true;
  final AddUserController usersController = AddUserController(baseUrl: 'http://10.0.2.2:8080');
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final fetchedUsers = await usersController.fetchUsers();
      setState(() {
        users = fetchedUsers;
        filteredUsers = fetchedUsers;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching users: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterUsers(String query) {
    final filtered = users.where((user) {
      final name = '${user['username']}'.toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredUsers = filtered;
    });
  }

  Future<void> deleteUser(String userId) async {
    try {
      final success = await usersController.deleteUser(userId);
      if (success) {
        setState(() {
          users.removeWhere((user) => user['id'] == userId);
          filteredUsers.removeWhere((user) => user['id'] == userId);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User deleted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete user.')),
        );
      }
    } catch (error) {
      print('Error deleting user: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _showUserDetails(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text('${user['username']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Role:', user['role']),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserPage(user: user),
                  ),
                ).then((updatedUser) {
                  if (updatedUser != null) {
                    setState(() {
                      final index = users.indexWhere((s) => s['id'] == updatedUser['id']);
                      if (index != -1) {
                        users[index] = updatedUser;
                        filterUsers(searchController.text); 
                      }
                    });
                  }
                });
              },
              child: const Text('Edit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showDeleteConfirmationDialog(user['id']);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text('Delete User'),
          content: const Text('Are you sure you want to permanently delete this User?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteUser(userId);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add User"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  AddUserPage()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onChanged: (query) => filterUsers(query),
          ),
          const SizedBox(height: 16),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredUsers.length,
                    itemBuilder: (context, index) {
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                              '${filteredUsers[index]['username']}'),
                          subtitle: Text('Role: ${filteredUsers[index]['role']}'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () => _showUserDetails(filteredUsers[index]),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}