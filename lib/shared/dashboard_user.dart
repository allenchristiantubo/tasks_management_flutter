import 'package:flutter/material.dart';

class DashboardUser extends StatelessWidget {
  const DashboardUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 64,
        margin: const EdgeInsets.only(top:10, bottom: 15),
        child:Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 32,
              backgroundImage: NetworkImage('https://scontent.fmnl17-3.fna.fbcdn.net/v/t1.6435-9/29062567_2240674839279747_4346929446729547776_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=09cbfe&_nc_eui2=AeF8WdsHmVqTNMNNmVx0Xsnnfc17Nz1e07l9zXs3PV7TubON2V3-KuPJnBfmItp2LhzsvNSMaPwNzd5tE6qZMuJq&_nc_ohc=0V0CoDuYossAX_bzue1&_nc_ht=scontent.fmnl17-3.fna&oh=00_AT-m2ZKGzaQTjj0yF5GGAByT15d0AzJoaij8GUJADbEKHw&oe=62D7B4D2'),
            ),
            const SizedBox(width: 15),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Allen Christian Tubo', style: TextStyle(fontFamily: "Poppins", color: Colors.black)),
                Text('/allentubo09', style: TextStyle(fontFamily: "Poppins", color:Colors.black)),
              ],
            ),
          ],
        )
    );
  }
}
