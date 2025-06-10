import os
import pandas as pd
from typing import List, Dict, Any 

class CEJCSeakerInfo:
    """CEJC（日常会話コーパス）の話者情報を扱うクラス
    """

    def __init__(self, 
                 cejc_dir: str="/autofs/diamond2/share/corpus/CEJC202304", 
                 cejc_orig_dir: str="/autofs/diamond2/share/corpus/CEJC"):
        """コンストラクタ

        Args:
            cejc_dir: CEJCのディレクトリパス（CEJC202304がある場合はそちらを指定するのが吉）
            cejc_orig_dir: CEJCのオリジナルデータのディレクトリパス（指定しない場合は cejc_dir と同じものとして扱う）
        """

        # ディレクトリパスの設定
        self.cejc_dir = cejc_dir
        
        # オリジナルデータのディレクトリパスの設定
        if cejc_orig_dir is not None:
            self.cejc_orig_dir = cejc_orig_dir
        else:
            self.cejc_orig_dir = cejc_dir

        # メタ情報ファイルの読み込み
        self.meta_info_filepath = os.path.join(
            cejc_dir, 'metaInfo', '会話・話者・協力者等のメタ情報.xlsx'
        )
        self.df = pd.read_excel(
            self.meta_info_filepath, 
            sheet_name='話者・会話対応表')

        # 話者IDの末尾に3桁の数字がついていないものは _000 を付与        
        self.df['話者ID改'] = self.df['話者ID'].apply(
            lambda x: x + '_000' if len(x) == 4 else x
        )

        # 音声ファイル名を付与．ただし個別ICがある人のみ
        wav_filenames = []
        for i, row in self.df.iterrows():
            speaker_label = row['話者ラベル']
            session_id = row['会話ID']
            if speaker_label[:2] == "IC":
                wav_filenames.append(f"{session_id}_{speaker_label[:4]}.wav")
            else:
                wav_filenames.append(None)
        self.df['音声ファイル名'] = wav_filenames


    def get_session_id_list(self) -> List[str]:
        """会話IDのリストを取得する

        Returns:
            会話IDのリスト
        """
        return self.df['会話ID'].unique().tolist()
    
    def get_speaker_id_list(self) -> List[str]:
        """話者IDのリストを取得する

        Returns:
            話者IDのリスト
        """
        return self.df['話者ID改'].unique().tolist()
    
    def get_speaker_info_in_session(self, session_id: str) -> Dict[str, Dict[str, str]]:
        """会話IDに対する話者情報を取得する.

        Args:
            session_id: 会話ID
        
        Returns:
            results["label2id"]: 話者ラベルから話者IDへの辞書
            results["id2label"]: 話者IDから話者ラベルへの辞書
            results["id2wavfilename"]: 話者IDから音声ファイル名への辞書
        """
        subdf = self.df[self.df['会話ID'] == session_id]
        if len(subdf) == 0:
            raise ValueError('No such session id: {}'.format(session_id))
        label2id = {}
        id2label = {}
        id2wavfilename = {}
        for i, row in subdf.iterrows():
            label2id[row['話者ラベル']] = row['話者ID改']
            id2label[row['話者ID改']] = row['話者ラベル']
            id2wavfilename[row['話者ID改']] = row['音声ファイル名']
        return {
            'label2id': label2id,
            'id2label': id2label,
            'id2wavfilename': id2wavfilename
        }
    
    def get_session_data_dirpath(self, session_id: str, orig_flag: bool=True) -> str:
        """会話IDに対するデータディレクトリのパスを取得する

        Args:
            session_id: 会話ID
            orig_flag: オリジナルデータのディレクトリを指定する場合は True

        Returns:
            データディレクトリのパス
        """
        if orig_flag:
            topdir = self.cejc_orig_dir
        else:
            topdir = self.cejc_dir
        subject_id = session_id[:4]
        session_base_id = session_id[:8]
        return os.path.join(
            topdir, 'data', subject_id, session_base_id)

    def get_session_suw_filepath(self, session_id: str) -> str:
        """会話IDに対するSUWファイルのパスを取得する

        Args:
            session_id: 会話ID

        Returns:
            SUWファイルのパス
        """
        dirpath = self.get_session_data_dirpath(session_id)
        return os.path.join(dirpath, session_id + '-SUW.csv')

    def get_session_wav_filepath(self, session_id: str, speaker_id: str) -> str:
        """会話IDに対する音声ファイルのパスを取得する

        Args:
            session_id: 会話ID
            speaker_id: 話者ID
        
        Returns:
            音声ファイルのパス
        """
        row = self.df[(self.df['会話ID'] == session_id) & (self.df['話者ID改'] == speaker_id)]
        if len(row) == 0:
            raise ValueError('No such condition (session_id: {}, speaker_id: {})'.format(session_id, speaker_id))
        wav_filename = row['音声ファイル名'].values[0]
        if wav_filename is not None:
            return os.path.join(
                self.get_session_data_dirpath(session_id),
                wav_filename)
        else:
            return None
        
        """
        speaker_info = self.get_speaker_info_in_session(session_id)
        wav_filename = speaker_info['id2wavfilename'][speaker_id]
        if wav_filename is not None:
            return os.path.join(
                self.get_session_data_dirpath(session_id, orig_flag=True),
                wav_filename)
        else:
            return None
        """
