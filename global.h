#import <pthread.h>

/* Externs */
extern int			tArgc;
extern char**		tArgv;
//extern char			vlc_command[1024];
//extern char			vlc_so_currentsong[1024];
extern pthread_t	main_tid;

extern char* wrap_set_vlc_so_currentsong(char* setter);
extern char* wrap_set_vlc_command(char* setter);
extern char* wrap_set_vlc_command_value(char* setter);
extern float wrap_set_iphone_audio_volume(float setter);
extern unsigned char* wrap_set_iphone_video_buffer(unsigned char* setter);

#define set_vlc_so_currentsong wrap_set_vlc_so_currentsong
#define set_vlc_command wrap_set_vlc_command
#define set_vlc_command_value wrap_set_vlc_command_value
#define set_iphone_audio_volume wrap_set_iphone_audio_volume
#define set_iphone_video_buffer wrap_set_iphone_video_buffer
