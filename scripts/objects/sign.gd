extends Object_

var audio
var audio_stream_player_2d : AudioStreamPlayer2D

func init():
	audio_stream_player_2d = get_parent().get_node("/root/Node2D/AudioStreamPlayer2D")
	if data.has("audio"):
		audio = data["audio"]
	print(audio)

func use():
	audio_stream_player_2d.stream.resource_path = audio
	audio_stream_player_2d.play()
	
func save_data():
	data["audio"] = audio


		
