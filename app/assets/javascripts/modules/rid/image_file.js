(function(angular){
    angular.module('rid-image-file', [])
        .directive('ridImageFile',[function(){
            return {
                scope: {
                    imageSrc: '=',
                    imageName: '=',
                    imageObject: '=',
                    onImagePostLoad: '='
                },
                link: function($scope, element, attrs) {
                    function readFile(file){
                        if (!angular.isDefined(file) ){
                            return;
                        }
                        if (!angular.isDefined(file.type) || !file.type.match('image.*')) {
                            return;
                        }
                        var newFileName = file.name;
                        var reader = new FileReader();
                        reader.onload = function(f){
                            var base64data = f.target.result;

                            $scope.$apply(function(){
                                if (angular.isDefined(attrs.imageSrc)){
                                    $scope.imageSrc = base64data;
                                }
                                if (angular.isDefined(attrs.imageName)){
                                    $scope.imageName = newFileName;
                                }
                                if (angular.isDefined(attrs.imageObject)){
                                    $scope.imageObject.imageSrc = base64data;
                                    $scope.imageObject.imageName = newFileName;
                                }
                                if (angular.isDefined(attrs.onImagePostLoad)){
                                    $scope.onImagePostLoad($scope, newFileName, base64data, file, element);
                                }
                            });
                        };

                        reader.readAsDataURL(file);
                    }
                    function stopEvent(evt){
                        evt.stopPropagation();
                        evt.preventDefault();
                        evt.dataTransfer.dropEffect = 'copy'; // Explicitly show this is a copy.
                    }
                    // input
                    element.on('change', function(){
                        var input = angular.element(this);
                        var file = input[0].files[0];
                        readFile(file);
                    });

                    // drop
                    var dropZone = element.closest(attrs.imageClosestDrop);
                    dropZone.on('click', function(){
                        element.trigger('click');
                        return false;
                    });
                    element.on('click', function(e){
                        e.stopPropagation();
                    });

                    if (!attrs.allowDrop){return;}

                    if (!angular.isDefined(attrs.imageClosestDrop)){
                        return;
                    }

                    dropZone.on('dragover', function(e) {
                        stopEvent(e);
                    }, false);

                    dropZone.on('dragenter', function(e) {
                        stopEvent(e);
                    }, false);

                    dropZone.on('drop', function(e){
                        e.preventDefault();

                        var file = e.originalEvent.dataTransfer.files[0];
                        readFile(file);
                    });
                }
            }
        }])
    ;
})(angular);