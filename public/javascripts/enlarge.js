(function($){
	
	$(document).ready(function(){
		//设置背景,加入文档流
		var back = document.createElement("div");
		$(back).addClass('back').hide().appendTo('body');
		
		//用来装图片和按钮
		var container = document.createElement("div");
		var image = document.createElement("img");
		var imageContainer = document.createElement("div");
		$(image).appendTo(imageContainer);
		$(imageContainer).addClass("imageContainer").appendTo(container);
		$(container).addClass('container').appendTo('body');
		
		//设置三个按钮,分别是放大,缩小和关闭图片,作为container的子节点,并设置属性
		var enlargeButton = document.createElement("input");
		enlargeButton.type = 'image';
		enlargeButton.src = '../images/enlargeButton.png';
		$(enlargeButton).addClass('enlargeButton').appendTo(container);
		
		var narrowButton = document.createElement("input");
		narrowButton.type = 'image';
		narrowButton.src = '../images/narrowButton.png';
		$(narrowButton).addClass('narrowButton').appendTo(container);
		
		var closeButton = document.createElement("input");
		closeButton.type = "image";
		closeButton.src = "../images/closeButton.png";
		$(closeButton).addClass('closeButton').appendTo(imageContainer);
		
		//为每一个商品的图片绑定一个点击事件,点击后会将图片展示给用户
		$('.entry img').each(function(){
			//click the picture and show details
			$(this).unbind('click').click(function(){
				image.src = this.src;
				var width = image.width;
				var addWidth = width / 10;
				var height = image.height;
				var addHeight = height / 10;
				
				$(image).css({
					'position':'relative',
					'left':($(imageContainer).width() - image.width)/2,
					'top':($(container).height() - image.height)/2
				});
				
				
				//图片定位
				$(container).animate({
					'left': ($('body').width() - $(container).width())/2, //此处不能使用container.width来获取,不知为何..
					'top':100
				}).show();
				
				//背景出现,遮盖屏幕
				$(back).animate({
					'width':$('body').width(),
					'height':document.body.clientHeight,
					'top':0,
					'left':8                                  //一定要设置好移动目的地的属性,top和left一定要设.
				}).show();
				
				//为点击按钮设置一个飞出屏幕的效果,绑定为click事件
				$(closeButton).click(function(){
					$(back).animate({
						'left':-2000,
						'top':-1600
					});
					$(container).animate({
						'left':-2000,
						'top':-1600
					});
					
					//重新调整好属性,在下次点击前可以恢复到原始状态
					image.width = width;
					image.height = height;
					enlargeButton.disabled = null;
					enlargeButton.src = "../images/enlargeButton.png";
					narrowButton.disabled = null;
					narrowButton.src = "../images/narrowButton.png";
				});
				
				
				//为放大和缩小两个按钮绑定点击事件
				$(enlargeButton).unbind('click').click(function(){
					if(image.width + addWidth <= 320 && image.height + addHeight <= 400)
					{
						image.width = image.width + addWidth;
						image.height = image.height + addHeight;
						if(narrowButton.disabled = "disabled"){           //有可能按放大是在最小时,此时缩小键应该是不可用的,必须让其重新生效,下同
							narrowButton.disabled = null;
							narrowButton.src = "../images/narrowButton.png";
						}
						$(image).css({
							'position':'relative',
							'left':($(imageContainer).width() - image.width)/2,
							'top':($(imageContainer).height() - image.height)/2
						});
					}
					else 
					{
						enlargeButton.disabled = 'disabled';
						enlargeButton.src = "../images/noEnlargeButton.png"
					}
				});
				
				$(narrowButton).unbind('click').click(function(){
					if(image.width - addWidth >=32 && image.height - addHeight >=40)
					{
						image.width = image.width - addWidth;
						image.height = image.height - addHeight;
						if(enlargeButton.disabled = "disabled"){
							enlargeButton.disabled = null;
							enlargeButton.src = "../images/enlargeButton.png";
						}
						$(image).css({
							'position':'relative',
							'left':($(imageContainer).width() - image.width)/2,
							'top':($(imageContainer).height() - image.height)/2
						});
					}
					else 
					{
						narrowButton.disabled = 'disabled';
						narrowButton.src = "../images/noNarrowButton.png";
					}
				});
			});
		});	
	});			
})(jQuery);
