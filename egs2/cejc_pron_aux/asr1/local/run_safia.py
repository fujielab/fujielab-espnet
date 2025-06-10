import os
import wave
import numpy as np
import argparse
from pylib.cejc_util import CEJCSpeakerInfo
from pylib.safia import apply_safia
import tqdm

def main(cejc_dir, cejc_16bit16kHz_dir, cejc_safia_dir):
    cejc_speaker_info = CEJCSpeakerInfo(cejc_dir)
    session_id_list = cejc_speaker_info.get_session_id_list()

    ### tmp
    # index_start = session_id_list.index("W005_001")
    # index_end = session_id_list.index("W006_001")
    # session_id_list = session_id_list[index_start:index_end]
    # print(f"session_id_list: {session_id_list}")
    # import sys
    # sys.exit()

    with tqdm.tqdm(total=len(session_id_list)) as pbar:
        for session_id in session_id_list:
            pbar.set_postfix({"session_id": session_id}, refresh=True)
            # Rest of the code
            id2wavdata = {}
            wav_len = -1
            speaker_info = cejc_speaker_info.get_speaker_info_in_session(session_id)

            # None以外のwavファイル名を取得
            wavfliename_list = list(speaker_info["id2wavfilename"].values())
            wavfliename_list = [x for x in wavfliename_list if x is not None]

            ###
            # if len(wavfliename_list) != 1:
            #     print("skipped.")
            #     continue

            for speaker_id in speaker_info["id2wavfilename"].keys():
                print(f"session_id: {session_id}, speaker_id: {speaker_id}")
                # if not session_id.startswith("W"):
                #     continue
                wav_path = cejc_speaker_info.get_session_wav_filepath(session_id, speaker_id)
                if wav_path is None:
                    print(f"warning: {speaker_id} has no wav file")
                    continue
                if cejc_16bit16kHz_dir is not None:
                    rel_wav_path = wav_path[len(cejc_dir):]
                    if rel_wav_path.startswith("/"):
                        rel_wav_path = rel_wav_path[1:]
                    wav_path = os.path.join(cejc_16bit16kHz_dir, rel_wav_path)

                try:
                    wf = wave.open(wav_path, 'r')
                except FileNotFoundError:
                    print(f"warning: {wav_path} not found")
                    continue
                channels = wf.getnchannels()
                assert channels == 1, f"channels must be 1, but {channels}"
                data = wf.readframes(wf.getnframes())
                wf.close()
                
                x = np.frombuffer(data, 'int16')
                if wav_len == -1:
                    wav_len = len(x)
                elif wav_len > len(x):
                    print(f"warning: {wav_path} has shorter length than the others. {len(x)} < {wav_len}")
                    x = np.pad(x, (0, wav_len - len(x)), "constant")
                elif wav_len < len(x):
                    print(f"warning: {wav_path} has longer length than the others. {len(x)} > {wav_len}")
                    x = x[:wav_len]

                id2wavdata[speaker_id] = x

            if len(id2wavdata) < 1: 
                print(f"no wav data for session {session_id}")
                pbar.update(1)
                continue
            elif len(id2wavdata) > 1:
                x = np.stack(list(id2wavdata.values()), axis=0)
                x_safia = apply_safia(x)
                ### 
                # print("skipped.")
                # continue
            else:
                x_safia = x.reshape(1, -1)

            for i, speaker_id in enumerate(id2wavdata.keys()):
                # 出力ファイル名を取得する
                wav_path = cejc_speaker_info.get_session_wav_filepath(session_id, speaker_id)
                rel_wav_path = wav_path[len(cejc_dir):]
                if rel_wav_path.startswith("/"):
                    rel_wav_path = rel_wav_path[1:]
                out_wav_path = os.path.join(cejc_safia_dir, rel_wav_path)
                # 出力ディレクトリを作成する
                os.makedirs(os.path.dirname(out_wav_path), exist_ok=True)

                wf = wave.open(out_wav_path, 'w')
                wf.setnchannels(1)
                wf.setframerate(16000)
                wf.setsampwidth(2)
                wf.writeframes(x_safia[i].tobytes())
                wf.close()

            pbar.update(1)
            pass

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--cejc_dir", help="Path to the CEJC directory", default="/autofs/diamond2/share/corpus/CEJC")
    parser.add_argument("--cejc_16bit16kHz_dir", help="Path to the output directory for 16bit 16kHz wav files", default="/autofs/diamond2/share/corpus/CEJC_16bit16kHz")
    parser.add_argument("--cejc_safia_dir", help="Path to the output directory for SAFIA files", default="/autofs/diamond2/share/corpus/CEJC_safia")
    args = parser.parse_args()

    main(args.cejc_dir, args.cejc_16bit16kHz_dir, args.cejc_safia_dir)
