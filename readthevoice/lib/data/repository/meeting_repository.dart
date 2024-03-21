/*
 void addUserDetail(String name) async{
    final database = await $FloorUserDatabase.databaseBuilder('floor_database.db').build();
    final userDao=database.userDao;
    UserDetails userDetails=UserDetails(1, name);
    await userDao.insertPerson(userDetails);
  }

// For fetching the UserDetails List
  void getUserList() async{
    final database = await $FloorUserDatabase.databaseBuilder('floor_database.db').build();
    final userDao=database.userDao;
    final result = await userDao.getAllUser();

  }
 */