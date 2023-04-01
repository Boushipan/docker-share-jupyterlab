# ベースイメージ名:タグ名
FROM continuumio/anaconda3:latest

# pipをアップグレードし必要なパッケージをインストール
RUN pip install --upgrade pip && \ 
    pip install autopep8 && \
    pip install Keras && \
    pip install tensorflow && \
    pip install opencv-python  && \
    pip install opencv-contrib-python && \
    pip install notion-client

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y libgl1-mesa-dev



# コンテナ側のルート直下にworkdir/（任意）という名前の作業ディレクトリを作り移動する
WORKDIR /workdir

RUN conda create -n myenv python=3.10

RUN /bin/bash -c ". activate myenv" 
   #&& conda install -c anaconda -y django  \
   #&& conda install -c conda-forge mysql-connector-python -y \
   #&& conda install -c conda-forge ezdxf -y 
   #&& conda install -c conda-forge opencv \
   #&& conda install -c anaconda matplotlib


   # && conda install -c conda-forge sshtunnel -y


# コンテナ側のリッスンポート番号
# 明示しているだけで、なくても動く
#EXPOSE 8888
#EXPOSE 8090

# ENTRYPOINT命令はコンテナ起動時に実行するコマンドを指定（基本docker runの時に上書きしないもの）
# "jupyter-lab" => jupyter-lab立ち上げコマンド
# "--ip=0.0.0.0" => ip制限なし
# "--port=8888" => EXPOSE命令で書いたポート番号と合わせる
# ”--no-browser” => ブラウザを立ち上げない。コンテナ側にはブラウザがないので 。
# "--allow-root" => rootユーザーの許可。セキュリティ的には良くないので、自分で使うときだけ。
# "--NotebookApp.token=''" => トークンなしで起動許可。これもセキュリティ的には良くない。

ENTRYPOINT ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

# CMD命令はコンテナ起動時に実行するコマンドを指定（docker runの時に上書きする可能性のあるもの）
# "--notebook-dir=/workdir" => Jupyter Labのルートとなるディレクトリを指定
CMD ["--notebook-dir=/workdir"]