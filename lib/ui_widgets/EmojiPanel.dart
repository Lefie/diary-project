
import 'package:diary/theme.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:flutter/cupertino.dart';

class EmojiPanel extends StatefulWidget{
  const EmojiPanel({super.key, required this.mood, required this.onMoodChanged});

  final String mood;
  final Function(String) onMoodChanged;

  @override
  State<EmojiPanel> createState() => _EmojiPanelState();

}

class _EmojiPanelState extends State<EmojiPanel> {
  String _cur_selected_mood = "";


  @override
  void initState() {
    super.initState();
    _cur_selected_mood = widget.mood;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width:300,
      color:AppColors.secondaryPurple,
      child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StyledEmojiButton(
                  emoji: AppEmojis.happy,
                  onPressed: (){
                    print("happy");
                    setState(() {
                      _cur_selected_mood = "happy";
                      widget.onMoodChanged("happy");
                    });
                  }, isSelected: _cur_selected_mood == "happy"),
              SizedBox(width:16),
              StyledEmojiButton(
                  emoji: AppEmojis.neutral,
                  onPressed: (){
                    setState(() {
                      _cur_selected_mood = "neutral";
                      widget.onMoodChanged("neutral");
                    });
                  }, isSelected: _cur_selected_mood == "neutral"),
              SizedBox(width:16),
              StyledEmojiButton(
                  emoji: AppEmojis.sad,
                  onPressed: (){
                    print("sad");
                    setState(() {
                      _cur_selected_mood = "sad";
                      widget.onMoodChanged("sad");
                    });
                    },
                  isSelected: _cur_selected_mood == "sad")
            ],
          ),
      ),
    );
  }
}