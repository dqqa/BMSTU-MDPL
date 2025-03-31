def cvt(color):
    return round((color/255)*63)

cnt = 0
while True:
    try:
        s = input()
    except:
        break

    for i in s.split():
        if cnt == 24:
            print("\\")
            cnt = 0
        cnt += 1
        print(f"{cvt(int(i))}, ", end="")
