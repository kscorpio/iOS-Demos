//
//  MovieStartPage.m
//  MovieStartPage
//
//  Created by liu on 16/4/20.
//  Copyright © 2016年 com.sylg. All rights reserved.
//

#import "MovieStartPage.h"
#import "ScrollPageView.h"
#import "Tevc.h"
//! 音视频部分
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface MovieStartPage ()
//! 音视频部分
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) AVAudioSession *avaudioSession;

@property (nonatomic, strong) UIView *alpaView;

@property (nonatomic, strong) ScrollPageView * scrollView;

@end

@implementation MovieStartPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self makeVideoPartLayout];
   [self makeScrollPartLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self start];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self stop];
}
-(void)start{
    if (self.moviePlayer!=nil&&[self.moviePlayer playbackState]==MPMoviePlaybackStateStopped) {
        NSLog(@" start");
        [self.moviePlayer play];
    }
    if (self.scrollView!=nil) {
        [self.scrollView setupTimer];
    }
    
}
-(void)stop{
    if (self.moviePlayer!=nil&&[self.moviePlayer playbackState]!=MPMoviePlaybackStateStopped) {
        NSLog(@" stop");
        [self.moviePlayer stop];
    }
    if (self.scrollView!=nil) {
        [self.scrollView stopTimer];
    }
}

#pragma mark -  横向滚动scroll 部分
- (void)makeScrollPartLayout{
    CGFloat screen_wid=self.view.frame.size.width;
    CGFloat screen_hei=self.view.frame.size.height;
    self.scrollView=[[ScrollPageView alloc]initWithFrame:CGRectMake(0 , 0, screen_wid, screen_hei-200) withNumOfPages:4];
    [self.view addSubview:self.scrollView];
  
    UIButton *bu=[[UIButton alloc]init];
    bu.frame=CGRectMake(20, screen_hei-150, 50, 30);
    bu.backgroundColor=[UIColor redColor];
    [bu addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bu];

}
-(void)click{
    Tevc *vc=[[Tevc alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark -  视频播放 部分
/*!
 *  @author LQX, 16-04-20
 *
 *  @brief 初始化 视频播放组件 背景蒙版
 */
-(void)makeVideoPartLayout{
    /**
     *  设置其他音乐软件播放的音乐不被打断
     */
    
    self.avaudioSession = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [self.avaudioSession setCategory:AVAudioSessionCategoryAmbient error:&error];
    
    
    
    NSString *urlStr = [[NSBundle mainBundle]pathForResource:@"1.mp4" ofType:nil];
    
    NSURL *url = [NSURL fileURLWithPath:urlStr];
    
    self.moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
    //    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    [self.moviePlayer.view setFrame:self.view.bounds];

    [self.view addSubview:self.moviePlayer.view];
    [self.moviePlayer setShouldAutoplay:YES];
    [self.moviePlayer setControlStyle:MPMovieControlStyleNone];
    [self.moviePlayer setFullscreen:YES];
    [self.moviePlayer setRepeatMode:MPMovieRepeatModeOne];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(playbackStateChanged)
//                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
//                                               object:self.moviePlayer];
    
    self.alpaView=[[UIView alloc]init];
    self.alpaView.frame=self.view.frame;
    self.alpaView.backgroundColor = [UIColor clearColor];
    [self.moviePlayer.view addSubview:_alpaView];
}



-(void)playbackStateChanged{
    //取得目前状态
    MPMoviePlaybackState playbackState = [_moviePlayer playbackState];
    
    //状态类型
    switch (playbackState) {
        case MPMoviePlaybackStateStopped:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStatePlaying:
            NSLog(@"播放中");
            break;
            
        case MPMoviePlaybackStatePaused:
            [_moviePlayer play];
            break;
            
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放被中断");
            break;
            
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"往前快转");
            break;
            
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"往后快转");
            break;
            
        default:
            NSLog(@"无法辨识的状态");
            break;
    }
}


#pragma mark - ios以后隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
